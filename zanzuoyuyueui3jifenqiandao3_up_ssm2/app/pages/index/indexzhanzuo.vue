<!-- 座位查询与预约 - 现代简约风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        title="座位预约查询"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="true"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <view class="filter-sticky">
      <!-- 1. 顶部筛选条件 - 优化布局 -->
      <view class="filter-box">
        <view class="filter-grid">
          <view class="filter-row">
            <view class="filter-item full-width">
              <ideadatetime mode="date" v-model="riqi" label="预约日期"></ideadatetime>
            </view>
          </view>
          <view class="filter-row">
            <view class="filter-item">
              <ideaselect label="选择时段" showName="title" :datalist="[shiduanlist]" v-model="sobj"></ideaselect>
            </view>
            <view class="btn-item">
              <u-button
                  @click="refresh"
                  type="primary"
                  text="实时查询"
                  size="small"
                  :customStyle="{ height: '70rpx', borderRadius: '12rpx', width: '160rpx', fontSize: '26rpx', fontWeight: 'bold' }"
              ></u-button>
            </view>
          </view>
        </view>
      </view>

      <!-- 2. 楼层/自习室切换 -->
      <view class="room-tabs">
        <scroll-view scroll-x class="tabs-scroll" :show-scrollbar="false">
          <view
              v-for="(item, index) in roomlist"
              :key="index"
              :class="['tab-item', currentRoomIndex === index ? 'active' : '']"
              @click="switchRoom(index)"
          >
            {{ item.title }}
          </view>
        </scroll-view>
      </view>
    </view>

    <scroll-view scroll-y class="content-scroll">
      <!-- 3. 座位图例 -->
      <view class="legend-bar" v-if="datalist.length > 0">
        <view class="legend-item">
          <view class="l-box available"></view>
          <text>可预约</text>
        </view>
        <view class="legend-item">
          <view class="l-box occupied"></view>
          <text>已预约</text>
        </view>
        <view class="legend-item">
          <view class="l-box maintenance"></view>
          <text>维修中</text>
        </view>
      </view>

      <!-- 4. 座位显示区域 -->
      <view class="seat-grid-container" v-if="datalist.length > 0">
        <view class="room-map-box">
          <view class="door-indicator">入口</view>
          <view class="seat-grid">
            <block v-for="(item, index) in datalist" :key="index">
              <!-- 走廊占位 -->
              <view v-if="item.isAisle" :class="['aisle-space', item.aisleType === 'h' ? 'aisle-h' : 'aisle-v']">
                <view class="aisle-line"></view>
              </view>
              <!-- 正常座位 -->
              <view
                  v-else
                  @click="handleSeatClick(item)"
                  :class="['seat-unit', item.class]"
              >
                <text class="seat-num">{{ item.title }}</text>
                <view class="seat-icon-box">
                  <text class="seat-icon">🪑</text>
                </view>
              </view>
            </block>
          </view>
        </view>
        <view class="bottom-tips">
          <text>提示：选择绿色座位进行预约，请诚信预约</text>
        </view>
      </view>

      <!-- 暂无数据提示 -->
      <view v-else class="empty-state">
        <u-empty mode="search" text="选择日期和时段后点击查询"></u-empty>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, fileUrl } from '@/common/config/api.js';
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      roomlist: [],
      shiduanlist: [],
      currentRoomIndex: 0,
      riqi: null,
      sobj: {}, // 选中的时段
      datalist: [], // 座位列表
      fileUrl: fileUrl,
      paytotal: 0 // 预约所需消耗（根据项目逻辑可调整）
    };
  },
  computed: {
    ...mapState(['userInfo']),
    selectedRoom() {
      return this.roomlist[this.currentRoomIndex] || {};
    }
  },
  onLoad() {
    this.initData();
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    async initData() {
      // 获取自习室/楼层
      const rooms = await listj({ params: { table: 'room' } });
      this.roomlist = rooms || [];
      
      // 获取时段
      const shiduans = await listj({ params: { table: 'shiduan' } });
      this.shiduanlist = shiduans || [];
      
      // 默认日期为明天
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      this.riqi = tomorrow.toISOString().split('T')[0];
    },
    
    switchRoom(index) {
      this.currentRoomIndex = index;
      if (this.riqi && this.sobj.id) {
        this.refresh();
      }
    },
    
    refresh() {
      if (!this.riqi || !this.sobj.id) {
        uni.showToast({ icon: 'none', title: '请先选择日期和时段' });
        return;
      }
      
      const pid = this.selectedRoom.id;
      if (!pid) return;

      // 1. 先检查自己是否已预约此时段
      findj({ params: { table: 'yuyue', ydate: this.riqi, shiduanid: this.sobj.id, uid: this.userInfo.id } }).then(res => {
        if (res) {
          uni.showModal({ title: "提示", content: "您已预约过此时段，不能重复预约", showCancel: false });
          this.datalist = [];
        } else {
          this.fetchSeatsStatus(pid);
        }
      });
    },

    async fetchSeatsStatus(pid) {
      // 2. 获取该房间所有座位
      const slist = await listj({ params: { table: 'site', pid: pid } });
      if (!slist) return;

      // 3. 获取该房间该时段已有的预约
      const ylist = await listj({ params: { table: 'yuyue', ydate: this.riqi, shiduanid: this.sobj.id, roomid: pid, statecn: '已预约' } });
      
      // 4. 模拟复杂布局：十字交叉路口式
      let layoutList = [];
      const rowSize = 6; // 最终 grid 的列数
      let seatCount = 0;
      
      for (let i = 0; i < slist.length; i++) {
        const s = slist[i];
        const isMaintenance = s.statecn === '维修中';
        const reservation = (ylist || []).find(y => String(y.siteid) === String(s.id));
        const isOccupied = !!reservation;
        
        let state = '可申请';
        let cls = 'zuowei';
        if (isMaintenance) { state = '维修中'; cls = 'zuoweim'; }
        else if (isOccupied) { state = '已占用'; cls = 'zuoweif'; }

        // 添加座位
        layoutList.push({
          ...s,
          uid: reservation ? reservation.uid : null,
          statecn_display: state,
          class: cls,
          isAisle: false
        });
        seatCount++;

        // 每2个座位后插入一个纵向走廊
        if (seatCount % 2 === 0) {
          layoutList.push({ isAisle: true, aisleType: 'v' });
        }

        // 每完成 2 行座位 (即 8 个座位 + 4 个纵向走廊 = 12 个槽位)，插入一整行横向走廊
        if (layoutList.length > 0 && layoutList.length % (rowSize * 2) === 0 && i < slist.length - 1) {
          for (let j = 0; j < rowSize; j++) {
            layoutList.push({ isAisle: true, aisleType: 'h' });
          }
        }
      }
      
      this.datalist = layoutList;
    },

    handleSeatClick(item) {
      if (item.class === 'zuoweif') {
        // 跳转到占位人的个人资料
        uni.navigateTo({
          url: `/pages/me/userprofile?uid=${item.uid}`
        });
        return;
      }
      if (item.class === 'zuoweim') {
        uni.showToast({ icon: 'none', title: '该位置正在维修中，暂不可用' });
        return;
      }

      // 计算预计积分
      let estMinutes = 0;
      if (this.sobj.title) {
        const times = this.sobj.title.split('-');
        if (times.length === 2) {
          const s = times[0].split(':');
          const e = times[1].split(':');
          const startMin = parseInt(s[0]) * 60 + parseInt(s[1]);
          const endMin = parseInt(e[0]) * 60 + parseInt(e[1]);
          estMinutes = endMin - startMin;
        }
      }

      uni.showModal({
        title: "确认预约",
        content: `楼层: ${this.selectedRoom.title}\n座位号: ${item.title}\n日期: ${this.riqi}\n时间: ${this.sobj.title}\n预计获得: ${estMinutes} 积分`,
        success: (res) => {
          if (res.confirm) {
            this.submitYuyue(item);
          }
        }
      });
    },

    async submitYuyue(seat) {
      // 参考 roomsite.vue 的预约逻辑
      // 1. 检查余额/积分（如果有消耗的话）
      /*let mymoney = (this.userInfo.money || 0) * 1;
      const cost = this.selectedRoom.total || 0;
      
      if (mymoney < cost) {
        uni.showToast({ icon: 'none', title: '余额不足，尝试提交...' });
      } else if (cost > 0) {
        mymoney -= cost;
        await savej({ params: { table: 'user', id: this.userInfo.id, money: mymoney } });
        this.userInfo.money = mymoney;
        this.updateUserInfo(this.userInfo);
      }*/

      // 2. 提交预约信息
      const fdata = {
        ydate: this.riqi,
        site: seat.title,
        siteid: seat.id,
        shiduanid: this.sobj.id,
        shiduan: this.sobj.title,
        room: this.selectedRoom.title,
        roomid: this.selectedRoom.id,
        username: this.userInfo.username,
        uid: this.userInfo.id,
        statecn: "已预约",
        tel: this.userInfo.tel,
        table: "yuyue",
        total: 0,
        sid: this.selectedRoom.sid, // 校区ID
        shop: this.selectedRoom.shop // 校区名称
      };

      savej({ params: fdata }).then(() => {
        uni.showToast({ title: '预约成功' });
        setTimeout(() => {
          uni.itool.nto({
              url:'/pages/yuyue/yuyue'
          })
        }, 1500);
      });
    },

    goBack() {
      uni.navigateBack();
    }
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f8fafc;
}

.filter-sticky {
  position: sticky;
  top: 0;
  z-index: 10;
  background-color: #ffffff;
  box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.05);
}

.filter-box {
  padding: 20rpx 30rpx;
  background-color: #ffffff;
}

.filter-grid {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.filter-row {
  display: flex;
  align-items: center;
  gap: 20rpx;
  width: 100%;
}

.filter-item {
  flex: 1;
  background-color: #f8fafc;
  padding: 10rpx 24rpx;
  border-radius: 12rpx;
  border: 1rpx solid #f1f5f9;
}

.full-width {
  width: 100%;
}

.btn-item {
  flex-shrink: 0;
}

.room-tabs {
  background-color: #ffffff;
  padding: 10rpx 0;
}

.tabs-scroll {
  white-space: nowrap;
  width: 100%;
}

.tab-item {
  display: inline-block;
  padding: 15rpx 40rpx;
  font-size: 28rpx;
  color: #64748b;
  position: relative;
  transition: all 0.3s;

  &.active {
    color: #3b82f6;
    font-weight: bold;
    
    &::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 40rpx;
      height: 6rpx;
      background-color: #3b82f6;
      border-radius: 3rpx;
    }
  }
}

.content-scroll {
  height: calc(100vh - 360rpx);
}

.legend-bar {
  display: flex;
  justify-content: center;
  gap: 40rpx;
  padding: 30rpx 0;
}

.legend-item {
  display: flex;
  align-items: center;
  font-size: 24rpx;
  color: #64748b;
}

.l-box {
  width: 28rpx;
  height: 28rpx;
  border-radius: 6rpx;
  margin-right: 12rpx;
  
  &.available {
    background-color: #ecfdf5;
    border: 1rpx solid #10b981;
  }
  
  &.occupied {
    background-color: #fef2f2;
    border: 1rpx solid #ef4444;
  }
  
  &.maintenance {
    background-color: #f1f5f9;
    border: 1rpx solid #94a3b8;
  }
}

.seat-grid-container {
  padding: 30rpx;
}

.room-map-box {
  background-color: #ffffff;
  border-radius: 32rpx;
  padding: 40rpx 20rpx;
  border: 4rpx solid #e2e8f0;
  box-shadow: 0 10rpx 30rpx rgba(0,0,0,0.02);
  position: relative;
}

.door-indicator {
  position: absolute;
  top: -20rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: #64748b;
  color: #fff;
  font-size: 20rpx;
  padding: 4rpx 24rpx;
  border-radius: 100rpx;
  z-index: 5;
}

.seat-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr); /* 6列：[座][座][廊][座][座][廊] */
  gap: 20rpx;
  align-items: center;
}

.aisle-space {
  display: flex;
  justify-content: center;
  align-items: center;
  
  &.aisle-v {
    height: 100%;
    .aisle-line {
      width: 4rpx;
      height: 60%;
      background-color: #f1f5f9;
      border-radius: 2rpx;
    }
  }
  
  &.aisle-h {
    height: 40rpx; /* 横向走廊高度 */
    grid-column: span 1;
    .aisle-line {
      width: 60%;
      height: 4rpx;
      background-color: #f1f5f9;
      border-radius: 2rpx;
    }
  }
}

.seat-unit {
  height: 120rpx;
  border-radius: 16rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  position: relative;
  
  &:active {
    transform: scale(0.92);
  }
}

.seat-num {
  font-size: 20rpx;
  font-weight: bold;
  color: inherit;
  margin-bottom: 4rpx;
  opacity: 0.8;
}

.seat-icon-box {
  background-color: rgba(255,255,255,0.3);
  width: 60rpx;
  height: 60rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.seat-icon {
  font-size: 32rpx;
}

.zuowei {
  background-color: #ecfdf5;
  border: 2rpx solid #10b981;
  color: #059669;
}

.zuoweif {
  background-color: #fef2f2;
  border: 2rpx solid #ef4444;
  color: #dc2626;
}

.zuoweim {
  background-color: #f1f5f9;
  border: 2rpx solid #94a3b8;
  color: #64748b;
}

.bottom-tips {
  margin-top: 50rpx;
  text-align: center;
  font-size: 22rpx;
  color: #94a3b8;
}

.empty-state {
  padding-top: 200rpx;
}

.safe-bottom {
  height: 60rpx;
}
</style>