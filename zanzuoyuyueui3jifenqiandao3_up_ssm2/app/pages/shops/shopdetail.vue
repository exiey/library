<!-- 自习室门店详情 - 沉浸式现代风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        :title="fobj.sname || '门店详情'"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 顶部大图展示 -->
      <view class="banner-section">
        <image class="banner-img" :src="fileUrl + fobj.img" mode="aspectFill"></image>
        <view class="banner-mask"></view>
      </view>

      <!-- 2. 悬浮信息卡片 -->
      <view class="info-card">
        <view class="shop-title-row">
          <text class="shop-name">{{ fobj.sname }}</text>
          <view class="fav-icon-btn" @tap="toggleFav">
            <text>{{ favtext === '加入收藏' ? '🤍' : '❤️' }}</text>
          </view>
        </view>

        <view class="detail-row" @tap="daohang">
          <text class="row-icon">📍</text>
          <text class="row-text">{{ fobj.address }}</text>
          <view class="route-btn">路线规划</view>
        </view>

        <view class="detail-row">
          <text class="row-icon">📞</text>
          <text class="row-text">联系电话：{{ fobj.tel }}</text>
        </view>
      </view>

      <!-- 3. 入口按钮组 -->
      <view class="action-section">
        <view class="main-cta" @tap="toRoom">
          <view class="cta-left">
            <text class="cta-title">进入教室预约</text>
            <text class="cta-sub">查看可用座位并在线选座</text>
          </view>
          <text class="cta-arrow">🪑 ➜</text>
        </view>
      </view>

      <!-- 4. 门店介绍文本 -->
      <view class="section-container">
        <view class="section-header">
          <view class="title-line"></view>
          <text class="section-title">门店介绍</text>
        </view>
        <view class="rich-content">
          <u-parse :content="fobj.note" />
        </view>
      </view>

      <!-- 5. 评论区原生实现 -->
      <view class="section-container">
        <view class="section-header">
          <view class="title-line"></view>
          <text class="section-title">用户评价 ({{ replaylist.length }})</text>
        </view>

        <view class="comment-list">
          <view class="comment-item" v-for="(item, index) in replaylist" :key="index">
            <view class="comment-avatar">👤</view>
            <view class="comment-body">
              <view class="comment-user-info">
                <text class="comment-user">{{ item.username }}</text>
                <text class="comment-date">{{ item.ndate }}</text>
              </view>
              <view class="comment-text">
                <text>{{ item.note }}</text>
              </view>
            </view>
          </view>

          <view v-if="replaylist.length === 0" class="empty-comment">
            <text>暂无评价，快来抢沙发吧~</text>
          </view>
        </view>
      </view>

      <!-- 6. 发表评论区域 -->
      <view class="input-section">
        <view class="input-wrapper">
          <u--textarea
              v-model="rnote"
              placeholder="写下你的体验感受..."
              border="none"
              height="80"
              customStyle="background-color: #f6f8fa; padding: 20rpx; border-radius: 16rpx;"
          ></u--textarea>
          <view class="submit-row">
            <u-button
                @click="replay()"
                type="primary"
                text="提交评论"
                size="small"
                :customStyle="{ width: '160rpx', margin: '0' }"
            ></u-button>
          </view>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 提示组件 -->
    <tn-tips ref="tips"></tn-tips>
  </view>
</template>

<script>
import { savej, listj, findj, fileUrl } from '@/common/config/api.js'
import { mapState, mapActions } from 'vuex'
import { ideautil, yewuutil } from '@/common/commontools.js'

export default {
  data() {
    return {
      pid: null,
      fileUrl: fileUrl,
      fobj: {},
      replaylist: [],
      rnote: '',
      favtext: '加入收藏'
    };
  },
  onLoad(params) {
    this.pid = params.pid
    this.fobjDetail()
  },
  methods: {
    ...mapActions(['setCar']),
    fobjDetail() {
      findj({ params: { table: 'shop', id: this.pid } }).then(res => {
        this.fobj = res
        this.fobj.note = ideautil.getHtmlNote(this.fobj.note)
        this.checkFavs()
        this.listReplay()
      })
    },
    toRoom() {
      uni.navigateTo({
        url: '/pages/roomsite/room?sid=' + this.fobj.id
      })
    },
    daohang() {
      // 原逻辑保留
      if(this.fobj.longitude && this.fobj.latitude) {
        uni.openLocation({
          latitude: parseFloat(this.fobj.latitude),
          longitude: parseFloat(this.fobj.longitude),
          name: this.fobj.sname,
          address: this.fobj.address
        })
      }
    },
    toggleFav() {
      let myfavs = String(this.userInfo.favs || "")
      if (this.favtext == "加入收藏") {
        myfavs = myfavs && myfavs !== '0' ? myfavs + "," + this.fobj.id : String(this.fobj.id)
      } else {
        myfavs = ideautil.removeStrInStr(this.fobj.id, myfavs) || "0"
      }
      savej({ params: { table: "user", favs: myfavs, id: this.userInfo.id } }).then(res => {
        this.userInfo.favs = myfavs
        this.checkFavs()
      })
    },
    checkFavs() {
      let myfavs = String(this.userInfo.favs || "")
      this.favtext = ideautil.checkStrInStr(this.fobj.id + "", myfavs) ? "移除收藏" : "加入收藏"
    },
    listReplay() {
      listj({ params: { table: 'replay', pid: this.fobj.id, type: 1 } }).then(res => {
        this.replaylist = res || []
      })
    },
    replay() {
      if (!this.rnote) return
      let fdata = {
        table: "replay",
        pid: this.fobj.id,
        note: this.rnote,
        uid: this.userInfo.id,
        username: this.userInfo.username,
        type: 1
      }
      savej({ params: fdata }).then(res => {
        this.listReplay()
        this.rnote = ""
        this.$refs.tips.show({ msg: '操作成功!' })
      })
    },
    goBack() {
      uni.navigateBack({ delta: 1 })
    }
  },
  computed: {
    ...mapState(['carlist', 'userInfo'])
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f7f9fb;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 顶部大图 */
.banner-section {
  height: 480rpx;
  position: relative;
  overflow: hidden;
}

.banner-img {
  width: 100%;
  height: 100%;
}

.banner-mask {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 160rpx;
  background: linear-gradient(to top, rgba(0,0,0,0.4), transparent);
}

/* 信息卡片 */
.info-card {
  margin: -80rpx 30rpx 30rpx;
  background: #fff;
  border-radius: 32rpx;
  padding: 40rpx 30rpx;
  position: relative;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.05);
  z-index: 5;
}

.shop-title-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.shop-name {
  font-size: 40rpx;
  font-weight: bold;
  color: #1a1a1a;
  flex: 1;
}

.fav-icon-btn {
  width: 80rpx;
  height: 80rpx;
  background: #fff5f5;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
}

.detail-row {
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;
  padding: 10rpx 0;
}

.row-icon {
  font-size: 32rpx;
  margin-right: 16rpx;
}

.row-text {
  font-size: 28rpx;
  color: #666;
  flex: 1;
  line-height: 1.4;
}

.route-btn {
  color: #4facfe;
  font-size: 24rpx;
  font-weight: bold;
  background: rgba(79, 172, 254, 0.1);
  padding: 8rpx 20rpx;
  border-radius: 100rpx;
  margin-left: 20rpx;
}

/* 按钮区 */
.action-section {
  padding: 0 30rpx;
  margin-bottom: 40rpx;
}

.main-cta {
  background: linear-gradient(135deg, #4facfe 0%, #00b4db 100%);
  border-radius: 24rpx;
  padding: 30rpx 40rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 10rpx 20rpx rgba(79, 172, 254, 0.2);
}

.cta-title {
  font-size: 32rpx;
  color: #fff;
  font-weight: bold;
  display: block;
  margin-bottom: 6rpx;
}

.cta-sub {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.8);
}

.cta-arrow {
  font-size: 40rpx;
}

/* 内容板块通用 */
.section-container {
  margin: 0 30rpx 40rpx;
  background: #fff;
  border-radius: 24rpx;
  padding: 30rpx;
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 30rpx;
}

.title-line {
  width: 8rpx;
  height: 30rpx;
  background: #4facfe;
  border-radius: 4rpx;
  margin-right: 16rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
  color: #333;
}

.rich-content {
  font-size: 28rpx;
  line-height: 1.6;
  color: #444;
}

/* 评论列表 */
.comment-list {
  margin-top: 10rpx;
}

.comment-item {
  display: flex;
  margin-bottom: 40rpx;
}

.comment-avatar {
  width: 80rpx;
  height: 80rpx;
  background: #f0f4f8;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  margin-right: 20rpx;
}

.comment-body {
  flex: 1;
}

.comment-user-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10rpx;
}

.comment-user {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
}

.comment-date {
  font-size: 22rpx;
  color: #999;
}

.comment-text {
  font-size: 26rpx;
  color: #555;
  background: #f8f9fa;
  padding: 20rpx;
  border-radius: 12rpx;
  line-height: 1.5;
}

.empty-comment {
  text-align: center;
  padding: 40rpx 0;
  color: #ccc;
  font-size: 24rpx;
}

/* 输入框 */
.input-section {
  margin: 0 30rpx 40rpx;
}

.input-wrapper {
  background: #fff;
  padding: 20rpx;
  border-radius: 24rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.02);
}

.submit-row {
  display: flex;
  justify-content: flex-end;
  margin-top: 16rpx;
}

.safe-bottom {
  height: 60rpx;
}

/* Web适配 */
@media screen and (min-width: 750px) {
  .content-scroll {
    max-width: 500px;
    margin: 0 auto;
    background: #f7f9fb;
  }
}
</style>