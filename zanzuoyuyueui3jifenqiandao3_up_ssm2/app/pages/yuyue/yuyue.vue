<!-- 我的预约 - 现代简约风格重构 -->
<template>
  <view class="page-container">
    <!-- 导航栏：白色背景，粗体标题 -->
    <u-navbar
        leftIconSize="0"
        title="我的预约"
        :border="false"
        :placeholder="true"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <!-- 状态切换栏：增强视觉引导 -->
    <view class="tab-wrapper">
      <u-tabs
          :list="typelist"
          keyName="title"
          @change="onTabChange"
          lineColor="#4facfe"
          :activeStyle="{ color: '#4facfe', fontWeight: 'bold', fontSize: '30rpx' }"
          :inactiveStyle="{ color: '#999', fontSize: '28rpx' }"
      ></u-tabs>
    </view>

    <scroll-view scroll-y class="content-scroll">
      <!-- 原生列表实现：替代 imglist -->
      <view class="reservation-list">
        <view
            class="order-card"
            v-for="(item, index) in fobjlist"
            :key="index"
            @tap="fobjDetail(item.id)"
            hover-class="card-hover"
        >
          <!-- 卡片头部：教室名称 + 状态标签 -->
          <view class="card-header">
            <view class="room-info">
              <text class="room-icon">🏢</text>
              <text class="room-name">{{ item.room }}</text>
            </view>
            <view :class="['status-badge', 
              item.statecn === '已预约' ? 'state-blue' :
              item.statecn === '已签到' ? 'state-green' :
              item.statecn === '暂时离开' ? 'state-orange' :
              item.statecn === '违规' ? 'state-red' :
              item.statecn === '已完成' ? 'state-gray' :
              item.statecn === '已评价' ? 'state-purple' : 'state-default'
            ]">
              {{ item.statecn }}
            </view>
          </view>

          <!-- 卡片主体：时间与座位 -->
          <view class="card-body">
            <view class="info-row">
              <text class="row-label">🕒 预约时段</text>
              <text class="row-value">{{ item.ydate }}</text>
            </view>
            <view class="info-row">
              <text class="row-label">🪑 预约座位</text>
              <text class="row-value">{{ item.site }}</text>
            </view>
          </view>

          <!-- 卡片底部：详情指引 -->
          <view class="card-footer">
            <text class="detail-tip">查看预约详情及签到码</text>
            <text class="arrow">➜</text>
          </view>
        </view>

        <!-- 空状态处理 -->
        <view v-if="fobjlist.length === 0" class="empty-state">
          <view class="empty-icon">📅</view>
          <text class="empty-text">暂无相关预约记录</text>
          <u-button
              v-if="tabtitle"
              text="查看全部"
              size="small"
              plain
              @click="resetTab"
              customStyle="margin-top: 20rpx; width: 200rpx;"
          ></u-button>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, deletej, fileUrl } from '@/common/config/api.js'
import { mapState, mapActions } from 'vuex'

export default {
  data() {
    return {
      fobjlist: [],
      tabtitle: null,
      typelist: [
        { title: '全部' },
        { title: '已预约' },
        { title: '已签到' },
        { title: '暂时离开' },
        { title: '违规' },
        { title: '已完成' },
        { title: '已评价' }
      ]
    };
  },
  onShow() {
    this.refreshBill()
  },
  methods: {
    ...mapActions(['updateUserInfo']),

    // 状态样式映射：避免在小程序中使用复杂逻辑
    getStatusStyle(status) {
      const map = {
        '已预约': 'state-blue',
        '已签到': 'state-green',
        '暂时离开': 'state-orange',
        '违规': 'state-red',
        '已完成': 'state-gray',
        '已评价': 'state-purple'
      };
      return map[status] || 'state-default';
    },

    onTabChange(item) {
      this.tabtitle = (item.title === '全部') ? null : item.title;
      this.refreshBill();
    },

    refreshBill() {
      uni.showLoading({ title: '加载中...' });
      listj({
        params: {
          table: 'yuyue',
          uid: this.userInfo.id,
          statecn: this.tabtitle
        }
      }).then(res => {
        const formatted = (res || []).map(s => {
          return {
            ...s,
            // 在 JS 层处理好时间拼接，避免在模板中写逻辑
            ydate: s.ydate + " " + s.shiduan
          }
        });
        this.fobjlist = formatted;
        uni.hideLoading();
      }).catch(() => uni.hideLoading());
    },

    resetTab() {
      // 用于快速返回全部列表
      uni.reLaunch({ url: '/pages/yuyue/yuyue' });
    },

    fobjDetail(bid) {
      uni.navigateTo({
        url: '/pages/yuyue/yuyuedetail?bid=' + bid
      });
    },

    goBack() {
      uni.ytool.toIndex();
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
/* 基础容器 */
.page-container {
  min-height: 100vh;
  background-color: #f6f8fb;
  display: flex;
  flex-direction: column;
}

.tab-wrapper {
  background-color: #ffffff;
  padding-bottom: 10rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.02);
  z-index: 10;
}

.content-scroll {
  flex: 1;
  height: 0;
}

/* 预约列表 */
.reservation-list {
  padding: 24rpx;
}

.order-card {
  background-color: #ffffff;
  border-radius: 24rpx;
  padding: 30rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.02);
  border: 1rpx solid #f0f3f6;
  transition: all 0.2s;
}

.card-hover {
  transform: scale(0.98);
  background-color: #fafbfc;
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
  padding-bottom: 20rpx;
  border-bottom: 2rpx dashed #f0f0f0;
}

.room-info {
  display: flex;
  align-items: center;
}

.room-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.room-name {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
}

/* 状态标签色值 */
.status-badge {
  font-size: 22rpx;
  padding: 6rpx 16rpx;
  border-radius: 8rpx;
  font-weight: 500;
}

.state-blue { background: rgba(79, 172, 254, 0.1); color: #4facfe; }
.state-green { background: rgba(16, 185, 129, 0.1); color: #10b981; }
.state-orange { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
.state-red { background: rgba(239, 68, 68, 0.1); color: #ef4444; }
.state-gray { background: #f1f5f9; color: #94a3b8; }
.state-purple { background: rgba(139, 92, 246, 0.1); color: #8b5cf6; }
.state-default { background: #eee; color: #666; }

/* 卡片主体 */
.card-body {
  margin-bottom: 24rpx;
}

.info-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16rpx;
}

.info-row:last-child {
  margin-bottom: 0;
}

.row-label {
  font-size: 26rpx;
  color: #999;
}

.row-value {
  font-size: 26rpx;
  color: #444;
  font-weight: 500;
}

/* 卡片底部 */
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f8f8f8;
}

.detail-tip {
  font-size: 24rpx;
  color: #bbb;
}

.arrow {
  font-size: 24rpx;
  color: #ccc;
}

/* 空状态 */
.empty-state {
  padding: 120rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.empty-icon {
  font-size: 100rpx;
  margin-bottom: 30rpx;
  opacity: 0.5;
}

.empty-text {
  font-size: 28rpx;
  color: #999;
}

.safe-bottom {
  height: 60rpx;
}

/* Web端适配 */
@media screen and (min-width: 750px) {
  .page-container {
    max-width: 500px;
    margin: 0 auto;
    border-left: 1rpx solid #eee;
    border-right: 1rpx solid #eee;
  }
}
</style>