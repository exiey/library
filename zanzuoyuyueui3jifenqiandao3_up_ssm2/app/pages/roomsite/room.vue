<!-- 自习室查询 - 蓝色现代风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        :title="title"
        bgColor="#ffffff"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 顶部推荐入口 - 升级为 Hero Card -->
      <view class="hero-section">
        <navigator url="/pages/roomsite/roomtuijian" hover-class="none">
          <view class="recommend-card">
            <view class="recommend-info">
              <text class="rec-title">智能匹配自习室</text>
              <text class="rec-sub">根据您的习惯推荐最适合的位置</text>
            </view>
            <view class="rec-icon">
              <text class="emoji-jump">⚡</text>
            </view>
          </view>
        </navigator>
      </view>

      <!-- 2. 自习室列表 - 原生实现 -->
      <view class="list-title-box">
        <text class="list-title">全部自习室</text>
        <text class="list-count">共 {{ fobjList.length }} 个</text>
      </view>

      <view class="room-grid">
        <view
            class="room-card"
            v-for="(item, index) in fobjList"
            :key="index"
            @tap="roomDetail(item.id)"
            hover-class="card-hover"
        >
          <view class="room-image-box">
            <image class="room-img" :src="fileUrl + item.img" mode="aspectFill"></image>
            <view class="room-tag">精品推荐</view>
          </view>

          <view class="room-info">
            <view class="room-header">
              <text class="room-name">{{ item.title }}</text>
              <text class="room-arrow">详情 →</text>
            </view>

            <text class="room-note">{{ item.note || '暂无环境说明' }}</text>

            <view class="room-features">
              <text class="feature-tag">🚭 禁烟</text>
              <text class="feature-tag">📶 WiFi</text>
              <text class="feature-tag">❄️ 空调</text>
            </view>
          </view>
        </view>

        <!-- 空状态 -->
        <view v-if="fobjList.length === 0" class="empty-state">
          <text class="empty-emoji">🏢</text>
          <text class="empty-txt">暂无相关自习室信息</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, deletej, fileUrl } from '@/common/config/api.js';
import { mapState, mapActions } from 'vuex';
import { ideautil, yewuutil } from '@/common/commontools.js';

export default {
  data() {
    return {
      fobjList: [],
      title: "自习室查询",
      fileUrl: fileUrl
    };
  },
  onLoad(params) {
    this.fetchRooms(params.sid);
  },
  methods: {
    fetchRooms(sid) {
      uni.showLoading({ title: '加载中...' });
      listj({ params: { table: 'room', sid: sid } }).then(res => {
        for (let s of res) {
            s.note = uni.itool.getSimpleText(s.note)
        }
        this.fobjList = res || [];
        uni.hideLoading();
      }).catch(() => uni.hideLoading());
    },
    roomDetail(id) {
      uni.navigateTo({
        url: '/pages/roomsite/roomdetail?id=' + id
      });
    },
    goBack() {
      uni.navigateBack({
        delta: 1
      });
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f7f9fc;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 顶部推荐卡片 */
.hero-section {
  padding: 30rpx;
}

.recommend-card {
  background: linear-gradient(135deg, #4facfe 0%, #00b4db 100%);
  border-radius: 30rpx;
  padding: 40rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 15rpx 30rpx rgba(79, 172, 254, 0.3);
  position: relative;
  overflow: hidden;
}

.recommend-card::after {
  content: '';
  position: absolute;
  right: -20rpx;
  top: -20rpx;
  width: 150rpx;
  height: 150rpx;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
}

.rec-title {
  font-size: 36rpx;
  color: #fff;
  font-weight: bold;
  display: block;
  margin-bottom: 8rpx;
}

.rec-sub {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.8);
}

.rec-icon {
  width: 90rpx;
  height: 90rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.emoji-jump {
  font-size: 40rpx;
}

/* 列表标题 */
.list-title-box {
  padding: 0 30rpx 20rpx;
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}

.list-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.list-count {
  font-size: 24rpx;
  color: #999;
}

/* 自习室卡片布局 */
.room-grid {
  padding: 0 30rpx;
}

.room-card {
  background: #fff;
  border-radius: 24rpx;
  overflow: hidden;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.02);
  transition: all 0.3s;
}

.card-hover {
  transform: scale(0.98);
  box-shadow: 0 10rpx 40rpx rgba(0, 0, 0, 0.05);
}

.room-image-box {
  width: 100%;
  height: 300rpx;
  position: relative;
}

.room-img {
  width: 100%;
  height: 100%;
}

.room-tag {
  position: absolute;
  top: 20rpx;
  left: 20rpx;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
  color: #fff;
  font-size: 20rpx;
  padding: 6rpx 16rpx;
  border-radius: 8rpx;
}

.room-info {
  padding: 24rpx;
}

.room-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}

.room-name {
  font-size: 32rpx;
  font-weight: bold;
  color: #1a1a1a;
}

.room-arrow {
  font-size: 22rpx;
  color: #4facfe;
  font-weight: 500;
}

.room-note {
  font-size: 24rpx;
  color: #666;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  margin-bottom: 20rpx;
}

.room-features {
  display: flex;
  gap: 12rpx;
}

.feature-tag {
  font-size: 20rpx;
  color: #888;
  background: #f0f3f6;
  padding: 6rpx 16rpx;
  border-radius: 6rpx;
}

/* 空状态 */
.empty-state {
  padding: 100rpx 0;
  text-align: center;
}
.empty-emoji { font-size: 80rpx; margin-bottom: 20rpx; display: block; }
.empty-txt { color: #999; font-size: 26rpx; }

.safe-bottom { height: 60rpx; }

/* PC端适配 */
@media screen and (min-width: 750px) {
  .content-scroll {
    max-width: 500px;
    margin: 0 auto;
    background: #fff;
    border-left: 1px solid #eee;
    border-right: 1px solid #eee;
  }
}
</style>