<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar title="个人资料与桌面" :border="false" :placeholder="true" @leftClick="goBack" :autoBack="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 用户基本资料 -->
      <view class="profile-header">
        <view class="header-bg"></view>
        <view class="user-card">
          <image class="avatar" :src="user.img ? fileUrl + user.img : 'https://via.placeholder.com/150?text=👤'"></image>
          <view class="user-info">
            <text class="username">{{ user.fname || user.username }}</text>
            <view class="stats-row">
              <view class="stat-item">
                <text class="stat-value">{{ totalDuration }}</text>
                <text class="stat-label">学习时长(分)</text>
              </view>
              <view class="stat-item">
                <text class="stat-value">{{ user.money || 0 }}</text>
                <text class="stat-label">累积积分</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 2. 用户桌面展示 -->
<!--      <view class="desktop-section">
        <view class="section-title">
          <text class="dot">●</text>
          <text>Ta的装饰桌面</text>
        </view>
        
        <view class="desktop-preview" :style="{ backgroundColor: desktopConfig.bgColor || '#ffffff' }">
          <view class="desktop-empty" v-if="desktopConfig.items && desktopConfig.items.length === 0">
            <text>Ta还没有装饰过桌面哦~ 🍃</text>
          </view>
          
          <view 
            v-for="(item, index) in desktopConfig.items" 
            :key="index" 
            class="preview-item"
            :style="{ left: item.x + 'px', top: item.y + 'px' }"
          >
            <image :src="fileUrl + item.img" class="item-img" mode="aspectFit"></image>
          </view>
        </view>
      </view>-->

      <!-- 3. 最近学习动态 (可选展示) -->
      <view class="activity-section" v-if="recentYuyue.length > 0">
        <view class="section-title">
          <text class="dot">●</text>
          <text>学习动态</text>
        </view>
        <view class="activity-list">
          <view v-for="(item, index) in recentYuyue" :key="index" class="activity-item">
            <view class="activity-dot"></view>
            <view class="activity-content">
              <text class="activity-time">{{ item.ydate }}</text>
              <text class="activity-desc">在 {{ item.room }} 坚持学习了 {{ item.duration }} 分钟</text>
            </view>
          </view>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { findj, listj, fileUrl } from '@/common/config/api.js';
import { ideautil } from '@/common/commontools.js';

export default {
  data() {
    return {
      uid: null,
      user: {},
      fileUrl: fileUrl,
      totalDuration: 0,
      desktopConfig: { items: [], bgColor: '#ffffff' },
      recentYuyue: []
    };
  },
  onLoad(params) {
    this.uid = params.uid;
    if (this.uid) {
      this.fetchUserData();
      this.fetchUserStudyStats();
    }
  },
  methods: {
    async fetchUserData() {
      const res = await findj({ params: { table: 'user', id: this.uid } });
      if (res) {
        this.user = res;
        /*if (res.desktop) {
          try {
            let jsonStr = res.desktop;
            // 处理可能的 Base64 编码
            if (typeof jsonStr === 'string' && !jsonStr.startsWith('{') && !jsonStr.startsWith('[')) {
              jsonStr = ideautil.base64Decode(jsonStr);
            }
            const config = typeof jsonStr === 'string' ? JSON.parse(jsonStr) : jsonStr;
            if (Array.isArray(config)) {
              this.desktopConfig = { items: config, bgColor: '#ffffff' };
            } else {
              this.desktopConfig = {
                items: config.items || [],
                bgColor: config.bgColor || '#ffffff'
              };
            }
          } catch (e) {
            console.error("解析用户桌面配置失败", e);
          }
        }*/
      }
    },
    async fetchUserStudyStats() {
      const res = await listj({
        params: {
          table: 'yuyue',
          uid: this.uid,
          statecn: '已完成'
        }
      });
      
      if (res && res.length > 0) {
        let total = 0;
        const activities = [];
        
        res.forEach(item => {
          if (item.stime && item.etime) {
            const sdate = new Date(item.stime.replace(/-/g, '/'));
            const edate = new Date(item.etime.replace(/-/g, '/'));
            const diffMin = Math.floor((edate.getTime() - sdate.getTime()) / (1000 * 60));
            if (diffMin > 0) {
              total += diffMin;
              item.duration = diffMin;
              activities.push(item);
            }
          }
        });
        
        this.totalDuration = total;
        // 只显示最近5条动态
        this.recentYuyue = activities.sort((a, b) => new Date(b.ydate) - new Date(a.ydate)).slice(0, 5);
      }
    },
    goBack() {
      uni.navigateBack();
    }
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f8fafc;
}

.content-scroll {
  height: calc(100vh - 44px);
}

.profile-header {
  position: relative;
  padding-bottom: 40rpx;
  
  .header-bg {
    height: 240rpx;
    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
    border-bottom-left-radius: 40rpx;
    border-bottom-right-radius: 40rpx;
  }
  
  .user-card {
    margin: -100rpx 30rpx 0;
    background: #ffffff;
    border-radius: 32rpx;
    padding: 40rpx;
    box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    align-items: center;
    
    .avatar {
      width: 160rpx;
      height: 160rpx;
      border-radius: 50%;
      border: 8rpx solid #ffffff;
      box-shadow: 0 8rpx 20rpx rgba(0, 0, 0, 0.1);
      margin-top: -120rpx;
      background-color: #f1f5f9;
    }
    
    .user-info {
      text-align: center;
      margin-top: 20rpx;
      width: 100%;
      
      .username {
        font-size: 36rpx;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 30rpx;
        display: block;
      }
      
      .stats-row {
        display: flex;
        justify-content: space-around;
        padding-top: 20rpx;
        border-top: 2rpx solid #f1f5f9;
        
        .stat-item {
          display: flex;
          flex-direction: column;
          align-items: center;
          
          .stat-value {
            font-size: 32rpx;
            font-weight: 800;
            color: #3b82f6;
          }
          
          .stat-label {
            font-size: 22rpx;
            color: #94a3b8;
            margin-top: 4rpx;
          }
        }
      }
    }
  }
}

.section-title {
  padding: 30rpx 40rpx;
  display: flex;
  align-items: center;
  font-size: 30rpx;
  font-weight: 800;
  color: #1e293b;
  
  .dot {
    color: #3b82f6;
    margin-right: 12rpx;
    font-size: 24rpx;
  }
}

.desktop-section {
  margin-bottom: 40rpx;
  
  .desktop-preview {
    margin: 0 30rpx;
    height: 400rpx;
    border-radius: 24rpx;
    position: relative;
    overflow: hidden;
    box-shadow: inset 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
    border: 4rpx solid #e2e8f0;
    
    .desktop-empty {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: #94a3b8;
      font-size: 24rpx;
    }
    
    .preview-item {
      position: absolute;
      width: 80rpx;
      height: 80rpx;
      
      .item-img {
        width: 100%;
        height: 100%;
      }
    }
  }
}

.activity-section {
  .activity-list {
    margin: 0 40rpx;
    padding-left: 20rpx;
    border-left: 2rpx dashed #e2e8f0;
  }
  
  .activity-item {
    position: relative;
    padding-bottom: 30rpx;
    padding-left: 30rpx;
    
    .activity-dot {
      position: absolute;
      left: -41rpx;
      top: 10rpx;
      width: 20rpx;
      height: 20rpx;
      background-color: #3b82f6;
      border-radius: 50%;
      border: 4rpx solid #ffffff;
      box-shadow: 0 0 10rpx rgba(59, 130, 246, 0.3);
    }
    
    .activity-content {
      .activity-time {
        font-size: 22rpx;
        color: #94a3b8;
        display: block;
      }
      .activity-desc {
        font-size: 26rpx;
        color: #475569;
        margin-top: 4rpx;
        display: block;
      }
    }
  }
}

.safe-bottom {
  height: 60rpx;
}
</style>
