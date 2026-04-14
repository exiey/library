<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar title="我的装饰桌面" :border="false" :placeholder="true" @leftClick="goBack" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>

    <!-- 1. 桌面装饰区域 -->
    <view class="desktop-area" :style="{ backgroundColor: bgColor }">
      <image class="desktop-bg" src="/static/images/desktop_bg.png" mode="aspectFill" v-if="hasBg"></image>
      <view class="desktop-empty" v-else-if="desktopItems.length === 0">
        <text>点击下方饰品装饰你的桌面吧 ✨</text>
      </view>

      <movable-area class="move-area">
        <movable-view
            v-for="(item, index) in desktopItems"
            :key="index"
            direction="all"
            :x="item.x"
            :y="item.y"
            class="move-item"
            @change="onMoveChange($event, index)"
        >
          <view class="item-wrapper">
            <image :src="fileUrl + item.img" class="item-img" mode="aspectFit"></image>
            <view class="delete-btn" @click="removeItem(index)">
              <u-icon name="close-circle-fill" color="#ff4d4f" size="16"></u-icon>
            </view>
          </view>
        </movable-view>
      </movable-area>
      
      <!-- 功能按钮组 -->
      <view class="desktop-actions">
        <view class="action-btn color-picker-btn" @click="showColorPicker = !showColorPicker">
          <u-icon name="eye-fill" :color="showColorPicker ? '#3b82f6' : '#64748b'" size="20"></u-icon>
          <text :style="{ color: showColorPicker ? '#3b82f6' : '#64748b' }">配色</text>
        </view>
        <view class="action-btn save-btn" @click="saveDesktop">
          <u-icon name="checkbox-mark" color="#fff" size="20"></u-icon>
          <text>保存</text>
        </view>
      </view>

      <!-- 颜色选择浮层 -->
      <view class="color-panel" v-if="showColorPicker">
        <view 
          v-for="(color, index) in presetColors" 
          :key="index" 
          class="color-dot" 
          :style="{ backgroundColor: color }"
          @click="changeBgColor(color)"
        >
          <u-icon name="checkmark" color="#fff" size="12" v-if="bgColor === color"></u-icon>
        </view>
      </view>
    </view>

    <!-- 2. 底部饰品栏 (Inventory) -->
    <view class="inventory-section">
      <view class="section-header">
        <text class="section-title">我的饰品库</text>
        <text class="section-subtitle">点击饰品摆放到桌面</text>
      </view>
      
      <scroll-view scroll-x class="inventory-scroll" :show-scrollbar="false">
        <view class="inventory-list">
          <view
              v-for="(item, index) in myGoods"
              :key="index"
              class="inventory-item"
              @click="addItemToDesktop(item)"
          >
            <image :src="fileUrl + item.img" class="inv-img" mode="aspectFit"></image>
            <text class="inv-name">{{ item.gname }}</text>
          </view>
          <view v-if="myGoods.length === 0" class="inv-empty">
            <text>去商城兑换些饰品吧~</text>
          </view>
        </view>
      </scroll-view>
    </view>
    
    <view class="safe-bottom"></view>
  </view>
</template>

<script>
import { listj, listSqlj, savej, fileUrl } from '@/common/config/api.js';
import { ideautil } from '@/common/commontools.js';
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      fileUrl: fileUrl,
      myGoods: [],
      desktopItems: [],
      hasBg: false,
      bgColor: '#ffffff',
      showColorPicker: false,
      presetColors: [
        '#ffffff', '#f8fafc', '#f1f5f9', '#fff1f2', '#fdf2f8', 
        '#f5f3ff', '#eff6ff', '#f0fdf4', '#fffbeb', '#fff7ed'
      ]
    };
  },
  computed: {
    ...mapState(['userInfo'])
  },
  onLoad() {
    this.fetchMyGoods();
    this.loadDesktop();
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    goBack() {
      uni.switchTab({ url: '/pages/me/me' });
    },
    // 1. 获取已购买的饰品
    async fetchMyGoods() {
      // 获取已付款或已完成的订单
      const bills = await listj({
        params: {
          table: 'bill',
          uid: this.userInfo.id,
          statecn: '已付款'
        }
      });
      
      const completedBills = await listj({
        params: {
          table: 'bill',
          uid: this.userInfo.id,
          statecn: '已完成'
        }
      });

      const allBills = [...(bills || []), ...(completedBills || [])];
      if (allBills.length === 0) return;

      // 提取去重后的商品ID
      const gids = Array.from(new Set(allBills.flatMap(b => (b.gids || '').split(',')).filter(id => id && id.trim())));
      if (gids.length === 0) return;

      // 获取商品详情
      const sql = `select * from wct_good where id in (${gids.join(',')})`;
      const goods = await listSqlj({ params: { sql: sql } });
      // 过滤掉非饰品类商品
      this.myGoods = goods || [];
    },

    // 2. 加载保存的桌面布局
    loadDesktop() {
      // 优先从数据库 (userInfo.desktop) 读取
      let savedData = this.userInfo.desktop;
      
      // 如果数据库没有，则尝试从本地存储读取 (平滑迁移)
      if (!savedData) {
        savedData = uni.getStorageSync(`desktop_${this.userInfo.id}`);
      }

      if (savedData) {
        try {
          // 如果数据是 Base64 编码的（以 eyJ 开头，通常是 JSON 的 Base64），先解码
          let jsonStr = savedData;
          if (typeof savedData === 'string' && !savedData.startsWith('{') && !savedData.startsWith('[')) {
            try {
              jsonStr = ideautil.base64Decode(savedData);
            } catch (e) {
              console.log("尝试 Base64 解码失败，可能已经是原字符串", e);
            }
          }

          const config = typeof jsonStr === 'string' ? JSON.parse(jsonStr) : jsonStr;
          if (Array.isArray(config)) {
            this.desktopItems = config;
          } else {
            this.desktopItems = config.items || [];
            this.bgColor = config.bgColor || '#ffffff';
          }
        } catch (e) {
          console.error("解析桌面配置失败", e);
        }
      }
    },

    // 3. 保存桌面布局到数据库
    saveDesktop() {
      const config = {
        items: this.desktopItems,
        bgColor: this.bgColor
      };
      const desktopStr = JSON.stringify(config);
      // 使用 Base64 编码以避免 GET 请求中的特殊字符导致后台解析报错
      const encodedDesktopStr = ideautil.base64Encode(desktopStr);
      
      uni.showLoading({ title: '保存中...' });
      
      // 1. 保存到数据库
      savej({
        params: {
          table: 'user',
          id: this.userInfo.id,
          desktop: encodedDesktopStr
        }
      }).then(() => {
        // 2. 同步更新本地 Vuex 状态
        let newUserInfo = { ...this.userInfo, desktop: encodedDesktopStr };
        this.updateUserInfo(newUserInfo);
        
        // 3. 同时更新本地缓存作为备份
        uni.setStorageSync(`desktop_${this.userInfo.id}`, encodedDesktopStr);
        
        uni.hideLoading();
        uni.showToast({ title: '布局及配色已保存到云端' });
      }).catch(err => {
        uni.hideLoading();
        uni.showToast({ title: '保存失败', icon: 'none' });
      });
    },

    // 4. 切换背景颜色
    changeBgColor(color) {
      this.bgColor = color;
    },

    // 4. 添加饰品到桌面
    addItemToDesktop(good) {
      this.desktopItems.push({
        id: good.id,
        img: good.img,
        x: 50,
        y: 50
      });
    },

    // 5. 移除饰品
    removeItem(index) {
      this.desktopItems.splice(index, 1);
    },

    // 6. 移动时更新坐标 (movable-view 仅更新显示，需要手动记录最终位置)
    onMoveChange(e, index) {
      if (e.detail.source === 'touch') {
        this.desktopItems[index].x = e.detail.x;
        this.desktopItems[index].y = e.detail.y;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: #f0f4f8;
}

.desktop-area {
  flex: 1;
  position: relative;
  background-color: #ffffff;
  margin: 20rpx;
  border-radius: 32rpx;
  box-shadow: inset 0 4rpx 20rpx rgba(0,0,0,0.05);
  overflow: hidden;
  border: 4rpx solid #e2e8f0;
}

.desktop-bg {
  width: 100%;
  height: 100%;
  position: absolute;
}

.desktop-empty {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #cbd5e1;
  font-size: 24rpx;
}

.move-area {
  width: 100%;
  height: 100%;
}

.move-item {
  width: 120rpx;
  height: 120rpx;
  z-index: 10;
}

.item-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
  
  .item-img {
    width: 100%;
    height: 100%;
  }
  
  .delete-btn {
    position: absolute;
    top: -10rpx;
    right: -10rpx;
    background: #fff;
    border-radius: 50%;
    padding: 2rpx;
    box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1);
    z-index: 15;
  }
}

.desktop-actions {
  position: absolute;
  bottom: 30rpx;
  right: 30rpx;
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  z-index: 20;
}

.action-btn {
  padding: 16rpx 32rpx;
  border-radius: 100rpx;
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 26rpx;
  box-shadow: 0 8rpx 20rpx rgba(0, 0, 0, 0.1);
  
  &:active {
    transform: scale(0.95);
  }
}

.color-picker-btn {
  background-color: #ffffff;
  color: #64748b;
}

.save-btn {
  background-color: #3b82f6;
  color: #ffffff;
}

.color-panel {
  position: absolute;
  bottom: 30rpx;
  left: 30rpx;
  background-color: rgba(255, 255, 255, 0.9);
  padding: 20rpx;
  border-radius: 30rpx;
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
  width: 300rpx;
  box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.08);
  backdrop-filter: blur(10px);
  z-index: 20;
}

.color-dot {
  width: 44rpx;
  height: 44rpx;
  border-radius: 50%;
  border: 4rpx solid #fff;
  box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
  justify-content: center;
}

.inventory-section {
  background-color: #ffffff;
  padding: 30rpx;
  border-radius: 40rpx 40rpx 0 0;
  box-shadow: 0 -10rpx 30rpx rgba(0,0,0,0.03);
}

.section-header {
  margin-bottom: 20rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #1e293b;
  display: block;
}

.section-subtitle {
  font-size: 22rpx;
  color: #94a3b8;
}

.inventory-scroll {
  width: 100%;
  white-space: nowrap;
}

.inventory-list {
  display: flex;
  gap: 24rpx;
  padding: 10rpx 0;
}

.inventory-item {
  width: 140rpx;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #f8fafc;
  padding: 16rpx;
  border-radius: 20rpx;
  border: 1rpx solid #f1f5f9;
  
  &:active {
    background-color: #eff6ff;
    border-color: #3b82f6;
  }
}

.inv-img {
  width: 80rpx;
  height: 80rpx;
  margin-bottom: 10rpx;
}

.inv-name {
  font-size: 20rpx;
  color: #64748b;
  width: 100%;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.inv-empty {
  padding: 40rpx;
  color: #94a3b8;
  font-size: 24rpx;
}

.safe-bottom {
  height: calc(20rpx + env(safe-area-inset-bottom));
  background-color: #ffffff;
}
</style>