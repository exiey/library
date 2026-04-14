<!-- 为我推荐 - 智能算法风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏：保持一致的白色简约风格 -->
    <u-navbar
        :title="title"
        bgColor="#ffffff"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        titleStyle="font-weight: bold; color: #333;"
        :autoBack="false"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 智能匹配头部装饰 -->
      <view class="ai-header">
        <view class="ai-content">
          <view class="ai-left">
            <text class="ai-title">智能匹配结果</text>
            <text class="ai-desc">已根据您的喜好偏好深度分析</text>
          </view>
          <view class="ai-icon-box">
            <text class="ai-pulse-icon">🧠</text>
          </view>
        </view>
        <!-- 装饰性光效 -->
        <view class="glow-light"></view>
      </view>

      <!-- 2. 推荐列表 -->
      <view class="list-container">
        <view class="list-label">
          <text class="label-text">✨ 猜你喜欢</text>
          <text class="label-sub">根据收藏记录推荐</text>
        </view>

        <view
            class="recommend-card"
            v-for="(item, index) in fobjList"
            :key="index"
            @tap="roomDetail(item.id)"
            hover-class="item-active"
        >
          <view class="card-image-box">
            <image class="card-img" :src="fileUrl + item.img" mode="aspectFill"></image>
            <view class="match-badge">
              <text>高匹配</text>
            </view>
          </view>

          <view class="card-info">
            <view class="info-top">
              <text class="room-title">{{ item.title }}</text>
              <text class="room-price">精品</text>
            </view>

            <text class="room-note">{{ item.note || '适合长期专注自习，环境优雅安静。' }}</text>

            <view class="card-footer">
              <view class="tag-row">
                <text class="tag">🎯 专属定制</text>
                <text class="tag">💎 优质空间</text>
              </view>
              <view class="go-btn">
                <text>详情</text>
                <text class="arrow">→</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 空状态：当算法未匹配到数据时 -->
        <view v-if="fobjList.length === 0" class="empty-box">
          <view class="empty-icon">🔍</view>
          <text class="empty-text">正在为您挖掘最适合的自习室...</text>
          <text class="empty-sub">尝试多多收藏喜欢的空间以完善推荐</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, deletej, fileUrl, listSqlj } from '@/common/config/api.js';
import { mapState, mapActions } from 'vuex';
import { ideautil, yewuutil } from '@/common/commontools.js';

export default {
  data() {
    return {
      fobjList: [],
      title: "为我推荐",
      fileUrl: fileUrl
    };
  },
  onLoad() {
    this.runRecommendationAlgorithm();
  },
  methods: {
    // 完整保留您的推荐算法逻辑，仅优化了数据获取后的交互
    runRecommendationAlgorithm() {
      uni.showLoading({ title: 'AI 深度分析中...' });

      listj({ params: { table: 'user' } }).then(userlist => {
        let tgids = "";
        let favs = this.userInfo.favs || "";

        // 计算相似度纬度
        let weidulist = [];
        for (let i = 0; i < userlist.length; i++) {
          let weidu = {};
          let user = userlist[i];
          if (user.id == this.userInfo.id) continue;

          let ufavs = user.favs;
          if (ufavs) {
            let wd = 0;
            ufavs += "";
            let ufarray = ufavs.split(",");
            if (favs) {
              favs += "";
              let farray = favs.split(",");
              for (let j = 0; j < ufarray.length; j++) {
                for (let k = 0; k < farray.length; k++) {
                  if (ufarray[j] == farray[k]) wd++;
                }
              }
              weidu.favs = ufavs;
              weidu.wd = wd;
              weidulist.push(weidu);
            } else {
              tgids = ufavs;
              break;
            }
          }
        }

        // 排序与筛选
        if (weidulist.length) {
          weidulist = weidulist.sort((o1, o2) => o2.wd - o1.wd);
          let len = Math.min(5, weidulist.length);
          let wfavs = "";
          for (let i = 0; i < len; i++) {
            wfavs += (wfavs === "" ? "" : ",") + weidulist[i]['favs'];
          }
          let wfarray = [...new Set(wfavs.split(","))]; // 去重
          tgids = wfarray.join(",");

          if (!tgids) tgids = this.userInfo.tags;
        }

        // SQL组装
        let tags = this.userInfo.tags;
        let sql = "select * from wct_room order by id desc";
        if (tgids) {
          sql = `select * from wct_room where id in (${tgids})`;
        }
        if (tags) {
          sql = `select * from wct_room where (id in (${tgids}) or typeid in (${tags}))`;
        }

        // 执行最终查询
        listSqlj({ params: { sql: sql } }).then(res => {
          this.fobjList = res || [];
          uni.hideLoading();
        }).catch(() => uni.hideLoading());
      }).catch(() => uni.hideLoading());
    },

    roomDetail(id) {
      uni.navigateTo({
        url: '/pages/room/roomdetail?id=' + id
      });
    },

    goBack() {
      uni.navigateBack({ delta: 1 });
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
  background-color: #f4f7fc;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 智能头部装饰 */
.ai-header {
  margin: 24rpx;
  padding: 40rpx;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border-radius: 40rpx;
  position: relative;
  overflow: hidden;
  box-shadow: 0 10rpx 30rpx rgba(79, 172, 254, 0.2);
}

.ai-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: relative;
  z-index: 2;
}

.ai-title {
  color: #ffffff;
  font-size: 36rpx;
  font-weight: bold;
  display: block;
  margin-bottom: 8rpx;
}

.ai-desc {
  color: rgba(255, 255, 255, 0.8);
  font-size: 24rpx;
}

.ai-icon-box {
  width: 100rpx;
  height: 100rpx;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.ai-pulse-icon {
  font-size: 50rpx;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
  100% { transform: scale(1); opacity: 1; }
}

.glow-light {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
}

/* 列表区 */
.list-container {
  padding: 0 24rpx;
}

.list-label {
  padding: 20rpx 10rpx;
  display: flex;
  align-items: baseline;
  gap: 16rpx;
}

.label-text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.label-sub {
  font-size: 22rpx;
  color: #999;
}

/* 推荐卡片样式 */
.recommend-card {
  background-color: #ffffff;
  border-radius: 30rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
  box-shadow: 0 6rpx 18rpx rgba(0, 0, 0, 0.03);
  display: flex;
  flex-direction: column;
}

.item-active {
  transform: scale(0.98);
}

.card-image-box {
  width: 100%;
  height: 320rpx;
  position: relative;
}

.card-img {
  width: 100%;
  height: 100%;
}

.match-badge {
  position: absolute;
  top: 24rpx;
  right: 24rpx;
  background: rgba(79, 172, 254, 0.9);
  color: white;
  padding: 6rpx 20rpx;
  border-radius: 100rpx;
  font-size: 20rpx;
  font-weight: bold;
  backdrop-filter: blur(4px);
}

.card-info {
  padding: 24rpx;
}

.info-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}

.room-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #1a1a1a;
}

.room-price {
  color: #4facfe;
  font-size: 24rpx;
  font-weight: bold;
}

.room-note {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
  margin-bottom: 24rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1rpx solid #f0f0f0;
  padding-top: 20rpx;
}

.tag-row {
  display: flex;
  gap: 12rpx;
}

.tag {
  font-size: 20rpx;
  color: #888;
  background: #f1f5f9;
  padding: 4rpx 16rpx;
  border-radius: 8rpx;
}

.go-btn {
  background-color: #4facfe;
  color: white;
  padding: 10rpx 24rpx;
  border-radius: 12rpx;
  font-size: 24rpx;
  display: flex;
  align-items: center;
  gap: 8rpx;
}

/* 空状态 */
.empty-box {
  padding: 120rpx 0;
  text-align: center;
}

.empty-icon {
  font-size: 100rpx;
  margin-bottom: 30rpx;
}

.empty-text {
  font-size: 30rpx;
  color: #333;
  font-weight: 500;
  display: block;
  margin-bottom: 12rpx;
}

.empty-sub {
  font-size: 24rpx;
  color: #999;
}

.safe-bottom {
  height: 60rpx;
}

/* 多端自适应 Web端 */
@media screen and (min-width: 750px) {
  .content-scroll {
    max-width: 480px;
    margin: 0 auto;
    background-color: #fff;
    box-shadow: 0 0 20rpx rgba(0,0,0,0.05);
  }
}
</style>