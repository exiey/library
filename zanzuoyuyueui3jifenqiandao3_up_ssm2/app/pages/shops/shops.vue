<!-- 自习室门店列表 - 蓝色简约现代风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        title="自习室"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 顶部欢迎语 -->
      <view class="header-hint">
        <text class="hint-main">选择您附近的自习空间</text>
        <text class="hint-sub">发现专注的力量 ✨</text>
      </view>

      <!-- 原生实现的门店列表 -->
      <view class="shop-list">
        <view
            class="shop-card"
            v-for="(item, index) in fobjList"
            :key="index"
            @tap="shopDetail(item.id)"
            hover-class="card-hover-effect"
        >
          <!-- 门店封面图容器 -->
          <view class="shop-image-wrapper">
            <image class="shop-img" :src="fileUrl + item.img" mode="aspectFill"></image>
            <view class="status-tag">营业中</view>
            <view class="image-overlay"></view>
          </view>

          <!-- 门店文字信息 -->
          <view class="shop-content">
            <view class="shop-header">
              <text class="shop-title">{{ item.sname || '自习空间' }}</text>
              <view class="rating">⭐⭐⭐⭐⭐</view>
            </view>

            <view class="shop-address">
              <text class="loc-icon">📍</text>
              <text class="address-text">{{ item.address || '地址详情见页面' }}</text>
            </view>

            <view class="shop-footer">
              <view class="features">
                <text class="feat-tag">WiFi</text>
                <text class="feat-tag">有座</text>
                <text class="feat-tag">安静</text>
              </view>
              <view class="enter-btn">
                <text>查看门店</text>
                <text class="arrow-icon">➜</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 数据为空时的处理 -->
        <view v-if="fobjList.length === 0" class="empty-box">
          <text class="empty-emoji">🏢</text>
          <text class="empty-text">暂无门店信息</text>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, deletej, fileUrl } from '@/common/config/api.js';
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      fobjList: [],
      fileUrl: fileUrl
    };
  },
  onLoad(params) {
    this.fetchShops();
  },
  methods: {
    fetchShops() {
      uni.showLoading({ title: '加载门店中...' });
      listj({ params: { table: 'shop' } }).then(res => {
        this.fobjList = res || [];
        uni.hideLoading();
      }).catch(err => {
        uni.hideLoading();
      });
    },
    shopGoods(sid) {
      uni.navigateTo({
        url: '/pages/good/goodview?sid=' + sid
      });
    },
    shopDetail(pid) {
      // 注意：此处逻辑保留您原有的参数传递
      uni.navigateTo({
        url: '/pages/shops/shopdetail?pid=' + pid
      });
    },
    goBack() {
      uni.switchTab({
        url: '/pages/index/index'
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
  background-color: #f8fafc;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 顶部引导 */
.header-hint {
  padding: 40rpx 32rpx;
  background-color: #ffffff;
}

.hint-main {
  font-size: 36rpx;
  font-weight: bold;
  color: #1e293b;
  display: block;
}

.hint-sub {
  font-size: 24rpx;
  color: #94a3b8;
  margin-top: 8rpx;
  display: block;
}

/* 列表容器 */
.shop-list {
  padding: 24rpx;
}

/* 门店卡片 */
.shop-card {
  background-color: #ffffff;
  border-radius: 32rpx;
  overflow: hidden;
  margin-bottom: 32rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.03);
  transition: all 0.3s ease;
}

.card-hover-effect {
  transform: translateY(-4rpx);
  box-shadow: 0 12rpx 30rpx rgba(0, 0, 0, 0.08);
}

/* 图片区域 */
.shop-image-wrapper {
  width: 100%;
  height: 360rpx;
  position: relative;
}

.shop-img {
  width: 100%;
  height: 100%;
}

.image-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 120rpx;
  background: linear-gradient(to top, rgba(0,0,0,0.4), transparent);
}

.status-tag {
  position: absolute;
  top: 24rpx;
  left: 24rpx;
  background-color: #10b981;
  color: #fff;
  font-size: 20rpx;
  padding: 6rpx 20rpx;
  border-radius: 100rpx;
  z-index: 2;
  box-shadow: 0 4rpx 10rpx rgba(16, 185, 129, 0.3);
}

/* 文字区域 */
.shop-content {
  padding: 24rpx;
}

.shop-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12rpx;
}

.shop-title {
  font-size: 34rpx;
  font-weight: bold;
  color: #0f172a;
}

.rating {
  font-size: 20rpx;
}

.shop-address {
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;
}

.loc-icon {
  font-size: 28rpx;
  margin-right: 12rpx;
}

.address-text {
  font-size: 26rpx;
  color: #64748b;
  line-height: 1.4;
  /* 两行省略 */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 1;
  overflow: hidden;
}

/* 底部标签与按钮 */
.shop-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 20rpx;
  border-top: 1rpx solid #f1f5f9;
}

.features {
  display: flex;
  gap: 12rpx;
}

.feat-tag {
  font-size: 20rpx;
  color: #4facfe;
  background-color: rgba(79, 172, 254, 0.1);
  padding: 4rpx 12rpx;
  border-radius: 8rpx;
}

.enter-btn {
  display: flex;
  align-items: center;
  color: #4facfe;
  font-size: 24rpx;
  font-weight: 600;
}

.arrow-icon {
  margin-left: 8rpx;
  transition: transform 0.2s;
}

.shop-card:active .arrow-icon {
  transform: translateX(6rpx);
}

/* 空状态 */
.empty-box {
  padding: 120rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.empty-emoji {
  font-size: 100rpx;
  margin-bottom: 20rpx;
}

.empty-text {
  font-size: 28rpx;
  color: #94a3b8;
}

.safe-bottom {
  height: 60rpx;
}

/* PC/Web端适配优化 */
@media screen and (min-width: 750px) {
  .content-scroll {
    max-width: 480px;
    margin: 0 auto;
    background-color: #fff;
    box-shadow: 0 0 20rpx rgba(0,0,0,0.05);
  }
}
</style>