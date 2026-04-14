<template>
  <view class="rank-page">
    <!-- 导航栏 -->
    <u-navbar title="学习成就榜" :border="false" :placeholder="true" @leftClick="goBack" :autoBack="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>

    <view class="rank-tabs">
      <view class="tab-item" :class="{ active: currentTab === 'daily' }" @click="switchTab('daily')">日榜</view>
      <view class="tab-item" :class="{ active: currentTab === 'weekly' }" @click="switchTab('weekly')">周榜</view>
      <view class="tab-item" :class="{ active: currentTab === 'all' }" @click="switchTab('all')">总榜</view>
    </view>

    <scroll-view scroll-y class="svcontainer">
      <!-- 第一部分：前三名 -->
      <view v-if="rankList.length > 0" class="honor-section">
        <view class="podium">
          <!-- 第二名 (左) -->
          <view v-if="rankList[1]" class="podium-item silver" @click="toUserProfile(rankList[1].id)">
            <view class="avatar-wrap">
              <text class="crown">🥈</text>
              <image class="avatar" :src="rankList[1].img ? fileUrl + rankList[1].img : 'https://via.placeholder.com/100?text=👤'"></image>
            </view>
            <text class="name">{{ rankList[1].fname || rankList[1].username }}</text>
            <view class="score-badge">{{ rankList[1].total_duration }} min</view>
          </view>

          <!-- 第一名 (中) -->
          <view v-if="rankList[0]" class="podium-item gold" @click="toUserProfile(rankList[0].id)">
            <view class="avatar-wrap">
              <text class="crown main-crown">🏆</text>
              <image class="avatar main-avatar" :src="rankList[0].img ? fileUrl + rankList[0].img : 'https://via.placeholder.com/100?text=👑'"></image>
            </view>
            <text class="name main-name">{{ rankList[0].username }}</text>
            <view class="score-badge main-badge">{{ rankList[0].total_duration }} min</view>
          </view>

          <!-- 第三名 (右) -->
          <view v-if="rankList[2]" class="podium-item bronze" @click="toUserProfile(rankList[2].id)">
            <view class="avatar-wrap">
              <text class="crown">🥉</text>
              <image class="avatar" :src="rankList[2].img ? fileUrl + rankList[2].img : 'https://via.placeholder.com/100?text=👤'"></image>
            </view>
            <text class="name">{{ rankList[2].username }}</text>
            <view class="score-badge">{{ rankList[2].total_duration }} min</view>
          </view>
        </view>
      </view>

      <!-- 第二部分：完整排名列表 -->
      <view class="list-section" v-if="rankList.length > 3">
        <view class="rank-item" v-for="(item, index) in rankList.slice(3)" :key="index" @click="toUserProfile(item.id)">
          <text class="rank-num">{{ index + 4 }}</text>
          <image class="item-avatar" :src="item.img ? fileUrl + item.img : 'https://via.placeholder.com/100?text=👤'"></image>
          <view class="item-info">
            <text class="item-name">{{ item.username }}</text>
            <text class="item-tips">坚持就是胜利</text>
          </view>
          <view class="item-score">
            <text class="score-val">{{ item.total_duration }}</text>
            <text class="score-unit">min</text>
          </view>
        </view>
      </view>

      <!-- 无数据状态 -->
      <view v-if="rankList.length === 0" class="empty-state">
        <text class="empty-icon">📊</text>
        <text class="empty-text">该时段暂无榜单数据，快去自习吧~</text>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, listSqlj, fileUrl } from '@/common/config/api.js';

export default {
  data() {
    return {
      fileUrl: fileUrl,
      currentTab: 'daily',
      rankList: [],
      loading: false
    };
  },
  onLoad() {
    this.refresh();
  },
  methods: {
    switchTab(tab) {
      if (this.currentTab === tab) return;
      this.currentTab = tab;
      this.refresh();
    },
    async refresh() {
      this.loading = true;
      let sql = '';
      const today = new Date().toISOString().split('T')[0];
      
      if (this.currentTab === 'daily') {
        sql = `SELECT uid, SUM(TIMESTAMPDIFF(MINUTE, REPLACE(stime, '-', '/'), REPLACE(etime, '-', '/'))) as total_duration 
               FROM wct_yuyue 
               WHERE (statecn = '已完成' OR statecn = '已评价') AND ydate = '${today}'
               GROUP BY uid 
               ORDER BY total_duration DESC`;
      } else if (this.currentTab === 'weekly') {
        const lastWeek = new Date();
        lastWeek.setDate(lastWeek.getDate() - 7);
        const lastWeekDate = lastWeek.toISOString().split('T')[0];
        sql = `SELECT uid, SUM(TIMESTAMPDIFF(MINUTE, REPLACE(stime, '-', '/'), REPLACE(etime, '-', '/'))) as total_duration 
               FROM wct_yuyue 
               WHERE (statecn = '已完成' OR statecn = '已评价') AND ydate >= '${lastWeekDate}'
               GROUP BY uid 
               ORDER BY total_duration DESC`;
      } else {
        sql = `SELECT uid, SUM(TIMESTAMPDIFF(MINUTE, REPLACE(stime, '-', '/'), REPLACE(etime, '-', '/'))) as total_duration 
               FROM wct_yuyue 
               WHERE (statecn = '已完成' OR statecn = '已评价')
               GROUP BY uid 
               ORDER BY total_duration DESC`;
      }

      try {
        const res = await listSqlj({ params: { sql: sql } });
        if (res && res.length > 0) {
          const uids = res.map(item => item.uid).filter(id => id);
          if (uids.length > 0) {
            const userSql = `SELECT id, username, fname, img FROM wct_user WHERE id IN (${uids.join(',')})`;
            const users = await listSqlj({ params: { sql: userSql } });
            
            // 合并用户数据
            this.rankList = res.map(item => {
              const user = users.find(u => String(u.id) === String(item.uid));
              return {
                ...item,
                ...user,
                total_duration: item.total_duration || 0
              };
            });
          } else {
            this.rankList = [];
          }
        } else {
          this.rankList = [];
        }
      } catch (e) {
        console.error('获取排行榜失败', e);
        // 如果后端不支持 TIMESTAMPDIFF 这种高级 SQL，回退到 JS 处理逻辑
        this.fallbackRefresh();
      } finally {
        this.loading = false;
      }
    },
    async fallbackRefresh() {
      // 如果 listSqlj 失败（某些环境不支持高级 SQL），则先拉取所有已完成预约，再在前端分组计算
      const today = new Date().toISOString().split('T')[0];
      let ylist = await listj({ params: { table: 'yuyue', statecn: '已完成' } });
      
      if (this.currentTab === 'daily') {
        ylist = ylist.filter(y => y.ydate === today);
      } else if (this.currentTab === 'weekly') {
        const lastWeekDate = new Date();
        lastWeekDate.setDate(lastWeekDate.getDate() - 7);
        ylist = ylist.filter(y => new Date(y.ydate) >= lastWeekDate);
      }

      const userGroups = {};
      ylist.forEach(y => {
        if (y.stime && y.etime) {
          const s = new Date(y.stime.replace(/-/g, '/'));
          const e = new Date(y.etime.replace(/-/g, '/'));
          const duration = Math.floor((e.getTime() - s.getTime()) / (1000 * 60));
          if (duration > 0) {
            userGroups[y.uid] = (userGroups[y.uid] || 0) + duration;
          }
        }
      });

      const res = Object.keys(userGroups).map(uid => ({
        uid: uid,
        total_duration: userGroups[uid]
      })).sort((a, b) => b.total_duration - a.total_duration);

      if (res.length > 0) {
        const uids = res.map(item => item.uid);
        const userSql = `SELECT id, username, fname, img FROM wct_user WHERE id IN (${uids.join(',')})`;
        const users = await listSqlj({ params: { sql: userSql } });
        this.rankList = res.map(item => {
          const user = users.find(u => String(u.id) === String(item.uid));
          return { ...item, ...user };
        });
      } else {
        this.rankList = [];
      }
    },
    toUserProfile(uid) {
      uni.navigateTo({
        url: `/pages/me/userprofile?uid=${uid}`
      });
    },
    goBack() {
      uni.switchTab({ url: '/pages/index/index' });
    }
  }
};
</script>

<style lang="scss" scoped>
.rank-page {
  background-color: #f8fafc;
  min-height: 100vh;
}

.rank-tabs {
  display: flex;
  background-color: #ffffff;
  padding: 20rpx 40rpx;
  justify-content: space-around;
  border-bottom: 2rpx solid #f1f5f9;
  
  .tab-item {
    font-size: 28rpx;
    color: #94a3b8;
    position: relative;
    padding: 10rpx 20rpx;
    
    &.active {
      color: #3b82f6;
      font-weight: 800;
      
      &::after {
        content: '';
        position: absolute;
        bottom: -10rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 40rpx;
        height: 6rpx;
        background-color: #3b82f6;
        border-radius: 3rpx;
      }
    }
  }
}

.svcontainer {
  height: calc(100vh - 180rpx);
}

.honor-section {
  padding: 60rpx 30rpx 40rpx;
  background-color: #ffffff;
  margin-bottom: 20rpx;
  
  .podium {
    display: flex;
    justify-content: center;
    align-items: flex-end;
    
    .podium-item {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      
      .avatar-wrap {
        position: relative;
        margin-bottom: 20rpx;
        
        .avatar {
          width: 100rpx;
          height: 100rpx;
          border-radius: 50%;
          border: 4rpx solid #fff;
          box-shadow: 0 8rpx 20rpx rgba(0, 0, 0, 0.1);
          background-color: #f1f5f9;
        }
        
        .crown {
          position: absolute;
          top: -30rpx;
          left: 50%;
          transform: translateX(-50%);
          font-size: 44rpx;
          z-index: 10;
        }
        
        .main-avatar {
          width: 140rpx;
          height: 140rpx;
          border: 6rpx solid #fbbf24;
          box-shadow: 0 10rpx 30rpx rgba(251, 191, 36, 0.2);
        }
        
        .main-crown {
          font-size: 64rpx;
          top: -48rpx;
        }
      }
      
      .name {
        font-size: 24rpx;
        color: #475569;
        font-weight: 500;
        margin-bottom: 8rpx;
        max-width: 160rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
      
      .main-name {
        font-size: 30rpx;
        color: #1e293b;
        font-weight: 800;
      }
      
      .score-badge {
        font-size: 20rpx;
        padding: 4rpx 16rpx;
        border-radius: 100rpx;
        background-color: #f1f5f9;
        color: #64748b;
        font-weight: 700;
      }
      
      .main-badge {
        background-color: #fef3c7;
        color: #d97706;
      }
    }
  }
}

.list-section {
  padding: 0 30rpx;
}

.rank-item {
  display: flex;
  align-items: center;
  background-color: #ffffff;
  padding: 30rpx;
  border-radius: 24rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.02);
  
  &:active {
    transform: scale(0.98);
    background-color: #f8fafc;
  }
  
  .rank-num {
    width: 60rpx;
    font-size: 32rpx;
    font-weight: 800;
    color: #94a3b8;
    font-style: italic;
  }
  
  .item-avatar {
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;
    margin-right: 20rpx;
    background-color: #f1f5f9;
  }
  
  .item-info {
    flex: 1;
    
    .item-name {
      font-size: 28rpx;
      font-weight: 700;
      color: #1e293b;
      display: block;
    }
    
    .item-tips {
      font-size: 20rpx;
      color: #94a3b8;
      margin-top: 4rpx;
    }
  }
  
  .item-score {
    text-align: right;
    
    .score-val {
      font-size: 32rpx;
      font-weight: 800;
      color: #3b82f6;
    }
    
    .score-unit {
      font-size: 20rpx;
      color: #94a3b8;
      margin-left: 4rpx;
    }
  }
}

.empty-state {
  padding-top: 200rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .empty-icon {
    font-size: 120rpx;
    opacity: 0.3;
    margin-bottom: 20rpx;
  }
  
  .empty-text {
    font-size: 26rpx;
    color: #cbd5e1;
  }
}

.safe-bottom {
  height: 60rpx;
}
</style>
