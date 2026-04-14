<!-- 自习室详情 - 蓝色现代沉浸式风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        title="自习室详情"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 顶部实拍图 -->
      <view class="header-banner" v-if="fobj.img">
        <image class="banner-img" :src="fileUrl + fobj.img" mode="aspectFill"></image>
        <view class="banner-mask"></view>
      </view>

      <!-- 2. 信息主卡片 -->
      <view class="main-card">
        <view class="room-header">
          <text class="room-title">{{ fobj.title || '载入中...' }}</text>
          <view class="tag-row">
            <text class="status-tag">✨ 优质环境</text>
            <text class="status-tag">🔇 静音区</text>
          </view>
        </view>

        <!-- 价格展示 (如需要可取消注释) -->
        <!-- <view class="price-row">
          <text class="price-symbol">¥</text>
          <text class="price-value">{{ fobj.total || 0 }}</text>
          <text class="price-unit">/ 小时起</text>
        </view> -->
      </view>

      <!-- 3. 详情图文介绍 -->
      <view class="section-box">
        <view class="section-title">
          <view class="title-line"></view>
          <text>教室详情</text>
        </view>
        <view class="rich-content">
          <u-parse :content="fobj.note" />
        </view>
      </view>

      <!-- 4. 评价模块 (仅当 showpl 为 true 时显示) -->
      <view class="section-box eval-card" v-show="showpl">
        <view class="section-title">
          <view class="title-line orange"></view>
          <text>发表评价</text>
        </view>
        <view class="rate-box">
          <tn-rate v-model="pingfen" :size="40" activeColor="#4facfe"></tn-rate>
          <text class="rate-hint">您的评价将帮助更多人</text>
        </view>
        <view class="input-wrap">
          <tn-input
              v-model="rnote"
              type="textarea"
              placeholder="说说你的使用感受..."
              :border="false"
              :height="160"
              customStyle="background-color: #f8fafc; padding: 20rpx; border-radius: 16rpx;"
          />
        </view>
        <view class="submit-btn-box">
          <tn-button
              @click="replay()"
              backgroundColor="#4facfe"
              fontColor="#FFFFFF"
              width="100%"
              shadow
          >提交评价</tn-button>
        </view>
      </view>

      <!-- 5. 历史评价列表 (原生实现) -->
      <view class="section-box">
        <view class="section-title">
          <view class="title-line blue"></view>
          <text>所有评价 ({{ replaylist.length }})</text>
        </view>

        <view class="replay-list">
          <view class="replay-item" v-for="(item, index) in replaylist" :key="index">
            <view class="replay-header">
              <view class="user-info">
                <text class="user-avatar">👤</text>
                <text class="user-name">{{ item.username }}</text>
              </view>
              <text class="replay-date">{{ item.ndate }}</text>
            </view>
            <view class="replay-content">
              <text>{{ item.note }}</text>
            </view>
          </view>

          <view v-if="replaylist.length === 0" class="empty-hint">
            <text>暂无评价信息</text>
          </view>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 6. 底部功能栏 -->
    <view class="footer-bar">
      <view class="footer-inner">
        <view class="fav-action" @click="toggleFav">
          <text :class="['fav-icon', favtext === '移除收藏' ? 'active' : '']">{{ favtext === '移除收藏' ? '❤️' : '🤍' }}</text>
          <text class="fav-text">{{ favtext }}</text>
        </view>

        <view class="primary-btns">
          <view class="action-btn scan-btn" @click="saoyisao">
            <text>扫码预约</text>
          </view>
          <view class="action-btn query-btn" @click="toYuyue">
            <text>查询座位</text>
          </view>
        </view>
      </view>
    </view>

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
      gid: null,
      fileUrl: fileUrl,
      favtext: "加入收藏",
      fobj: {},
      replaylist: [],
      rnote: '',
      pingfen: 5,
      showpl: false
    };
  },
  onLoad(params) {
    this.gid = params.id
    if (params.showpl == 1) {
      this.showpl = true
    }
    this.fobjDetail()
  },
  methods: {
    ...mapActions(['setCar']),
    saoyisao() {
      // 保持原逻辑
      if(uni.itool && uni.itool.saoyisao) {
        uni.itool.saoyisao(() => {
          uni.navigateTo({
            url: '/pages/roomsite/roomsite?rid=' + this.fobj.id
          })
        })
      } else {
        uni.showToast({ title: '扫码功能暂未就绪', icon: 'none' })
      }
    },
    toYuyue() {
      uni.navigateTo({
        url: '/pages/roomsite/roomsite?rid=' + this.fobj.id
      })
    },
    fobjDetail() {
      findj({ params: { table: 'room', id: this.gid } }).then(res => {
        this.fobj = res
        this.fobj.note = ideautil.getHtmlNote(this.fobj.note)
        this.checkFavs()
        this.listReplay()
        this.putHistory()
      })
    },
    putHistory() {
      let id = String(this.gid)
      let hgids = uni.getStorageSync("his_ids")
      if (hgids) {
        if (!ideautil.checkStrInStr(id, hgids)) {
          hgids += "," + id
        }
      } else {
        hgids = id
      }
      uni.setStorageSync("his_ids", hgids)
    },
    toggleFav() {
      let myfavs = String(this.userInfo.favs || "")
      if (this.favtext == "加入收藏") {
        myfavs = (myfavs && myfavs != '0') ? (myfavs + "," + this.fobj.id) : String(this.fobj.id)
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
      let isfav = ideautil.checkStrInStr(this.fobj.id + "", myfavs)
      this.favtext = isfav ? "移除收藏" : "加入收藏"
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
        this.showpl = false
        this.rnote = ""
        this.$refs.tips.show({ msg: '评价成功!' })
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
  background-color: #f7f9fc;
}

.content-scroll {
  height: calc(100vh - 44px - 120rpx); /* 减去导航和底部栏高度 */
}

/* 顶部图片 */
.header-banner {
  width: 100%;
  height: 480rpx;
  position: relative;
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
  height: 120rpx;
  background: linear-gradient(to top, rgba(0,0,0,0.3), transparent);
}

/* 内容卡片 */
.main-card {
  margin: -60rpx 30rpx 30rpx;
  background: #ffffff;
  border-radius: 32rpx;
  padding: 40rpx 30rpx;
  position: relative;
  z-index: 5;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.05);
}

.room-title {
  font-size: 40rpx;
  font-weight: bold;
  color: #1a1a1a;
  display: block;
  margin-bottom: 20rpx;
}

.tag-row {
  display: flex;
  gap: 16rpx;
}

.status-tag {
  font-size: 22rpx;
  color: #4facfe;
  background: rgba(79, 172, 254, 0.1);
  padding: 6rpx 16rpx;
  border-radius: 8rpx;
}

/* 通用板块 */
.section-box {
  margin: 0 30rpx 30rpx;
  background: #ffffff;
  border-radius: 24rpx;
  padding: 30rpx;
}

.section-title {
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
.title-line.orange { background: #ff9d00; }

.section-title text {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
}

.rich-content {
  font-size: 28rpx;
  color: #666;
  line-height: 1.6;
}

/* 评价框美化 */
.eval-card {
  border: 2rpx solid rgba(79, 172, 254, 0.2);
}

.rate-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30rpx;
}

.rate-hint {
  font-size: 22rpx;
  color: #999;
  margin-top: 10rpx;
}

.submit-btn-box {
  margin-top: 24rpx;
}

/* 评价列表 */
.replay-list {
  margin-top: 10rpx;
}

.replay-item {
  padding-bottom: 30rpx;
  margin-bottom: 30rpx;
  border-bottom: 1rpx solid #f1f5f9;
}

.replay-item:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.replay-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16rpx;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-avatar {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.user-name {
  font-size: 28rpx;
  font-weight: bold;
  color: #444;
}

.replay-date {
  font-size: 22rpx;
  color: #999;
}

.replay-content {
  background-color: #f8fafc;
  padding: 20rpx;
  border-radius: 12rpx;
  font-size: 26rpx;
  color: #666;
  line-height: 1.5;
}

.empty-hint {
  text-align: center;
  color: #ccc;
  font-size: 24rpx;
  padding: 40rpx 0;
}

/* 底部功能栏 */
.footer-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 120rpx;
  background-color: #ffffff;
  box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
  z-index: 100;
  padding-bottom: env(safe-area-inset-bottom);
}

.footer-inner {
  height: 120rpx;
  display: flex;
  align-items: center;
  padding: 0 30rpx;
}

.fav-action {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 40rpx;
}

.fav-icon {
  font-size: 40rpx;
}

.fav-text {
  font-size: 20rpx;
  color: #666;
  margin-top: 4rpx;
}

.primary-btns {
  flex: 1;
  display: flex;
  gap: 20rpx;
}

.action-btn {
  flex: 1;
  height: 84rpx;
  border-radius: 42rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28rpx;
  font-weight: bold;
}

.scan-btn {
  background-color: #f0f7ff;
  color: #4facfe;
  border: 2rpx solid #4facfe;
}

.query-btn {
  background: linear-gradient(to right, #4facfe, #00b4db);
  color: #ffffff;
  box-shadow: 0 8rpx 20rpx rgba(79, 172, 254, 0.3);
}

.safe-bottom {
  height: 60rpx;
}

/* Web适配 */
@media screen and (min-width: 750px) {
  .content-scroll, .footer-bar {
    max-width: 500px;
    margin: 0 auto;
    left: 0; right: 0;
  }
}
</style>