<template>
  <view class="page-detail">
    <!-- 导航栏 -->
    <u-navbar
        title="详细内容"
        :border="false"
        :placeholder="true"
        :autoBack="true"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #1e293b;"
    ></u-navbar>

    <scroll-view :enable-flex="true" scroll-y class="svcontainer">
      <!-- 1. Hero Image Section -->
      <view class="hero-section" v-if="fobj.img">
        <image class="main-image" :src="fileUrl+fobj.img" mode="widthFix"></image>
      </view>

      <!-- 2. Content Card -->
      <view class="content-card">
        <view class="article-header">
          <text class="article-title">{{fobj.title}}</text>
          <view class="author-info">
            <view class="author-left">
              <text class="author-avatar">👤</text>
              <text class="author-name">{{fobj.username}}</text>
            </view>
            <text class="post-date">{{fobj.ndate || ''}}</text>
          </view>
        </view>

        <view class="article-body">
          <u-parse :content="fobj.note" />
        </view>

        <!-- Interaction Bar (Optional functionality preserved) -->
        <view class="interaction-bar" v-if="fobj.favcount !== undefined">
          <view class="fav-box" @click="toggleFav">
            <text class="fav-icon">{{ faviconurl === favfocus ? '❤️' : '🤍' }}</text>
            <text class="fav-count">{{fobj.favcount || 0}}</text>
          </view>
        </view>
      </view>

      <!-- 3. Comments Section -->
      <view class="comment-section">
        <view class="section-header">
          <text class="section-title">评论回复</text>
          <text class="section-count">({{replaylist.length}})</text>
        </view>

        <!-- Native Comment List Implementation -->
        <view class="comment-list" v-if="replaylist.length > 0">
          <view class="comment-item" v-for="(item, index) in replaylist" :key="index">
            <text class="user-icon">👤</text>
            <view class="comment-main">
              <view class="comment-top">
                <text class="user-name">{{item.username}}</text>
                <text class="comment-time">{{item.ndate}}</text>
              </view>
              <view class="comment-text">
                {{item.note}}
              </view>
            </view>
          </view>
        </view>

        <!-- Empty State -->
        <view class="empty-comment" v-else>
          <text class="empty-icon">💬</text>
          <text class="empty-text">暂时还没有评论，快来抢沙发吧</text>
        </view>
      </view>

      <!-- 4. Input Area -->
      <view class="reply-box-wrapper">
        <view class="reply-box-inner">
          <u--textarea
              v-model="rnote"
              placeholder="发表你的友善评论..."
              confirmType="done"
              :border="false"
              height="80rpx"
              customStyle="background-color: #f1f5f9; border-radius: 40rpx; padding: 10rpx 30rpx;"
          ></u--textarea>
          <view class="send-btn" @click="replay">
            <text class="send-text">发布</text>
          </view>
        </view>
      </view>

      <view class="safe-bottom-spacer"></view>
    </scroll-view>
  </view>
</template>

<script>
import { savej, listj, findj, fileUrl } from '@/common/config/api.js';
import {mapState, mapActions} from 'vuex';
import { ideautil, yewuutil } from '@/common/commontools.js';

export default {
  data() {
    return {
      id: null,
      fileUrl: fileUrl,
      fobj: {},
      replaylist: [],
      rnote: '',
      favfocus:'http://ideapic-1255600738.cos.ap-guangzhou.myqcloud.com/images/icons/favfocus.png',
      faviconurl:''
    };
  },
  onLoad(params) {
    this.id = params.id
    this.fobjDetail()
  },
  methods: {
    fobjDetail() {
      findj({params: {table: 'posts', id: this.id}}).then(res => {
        this.fobj = res
        this.checkFavs()
        this.listReplay()
      })
    },
    toggleFav() {
      let myfavs = this.userInfo.favs || ""
      let favcount = this.fobj.favcount || 0
      let isFav = ideautil.checkStrInStr(this.fobj.id+"", myfavs)

      if (!isFav) {
        myfavs = myfavs ? myfavs + "," + this.fobj.id : this.fobj.id + ""
        favcount += 1
      } else {
        myfavs = ideautil.removeStrInStr(this.fobj.id, myfavs) || "0"
        favcount -= 1
      }

      this.fobj.favcount = favcount
      savej({ params: { table: "user", favs: myfavs, id: this.userInfo.id } }).then(() => {
        this.userInfo.favs = myfavs
        this.checkFavs()
        savej({params: {table: "posts", id: this.fobj.id, favcount: favcount }})
      })
    },
    checkFavs() {
      let myfavs = this.userInfo.favs || ""
      let isfav = ideautil.checkStrInStr(this.fobj.id+"", myfavs)
      this.faviconurl = isfav ? this.favfocus : ''
    },
    listReplay(){
      listj({params: {table: 'replay', pid: this.id, type: 3}}).then(res => {
        this.replaylist = res
      })
    },
    replay(){
      if(!this.rnote) return;
      let fdata = {
        table:"replay",
        pid: this.fobj.id,
        note: this.rnote,
        uid: this.userInfo.id,
        username: this.userInfo.username,
        type: 3
      }
      savej({params: fdata}).then(() => {
        this.listReplay()
        this.rnote = ""
        uni.showToast({ title: '评价成功', icon: 'none' })
      })
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
.page-detail {
  background-color: #f8fafc;
  min-height: 100vh;
}

.svcontainer {
  height: calc(100vh - 44px);
}

/* 1. Header Image */
.hero-section {
  width: 100%;
  background-color: #ffffff;
  .main-image {
    width: 100%;
    display: block;
  }
}

/* 2. Content Card Area */
.content-card {
  background-color: #ffffff;
  margin: -40rpx 0 20rpx;
  border-radius: 40rpx 40rpx 0 0;
  padding: 40rpx 30rpx;
  position: relative;
  z-index: 10;
  box-shadow: 0 -10rpx 30rpx rgba(0,0,0,0.05);

  .article-header {
    margin-bottom: 40rpx;
    .article-title {
      font-size: 40rpx;
      font-weight: 800;
      color: #1e293b;
      line-height: 1.4;
      margin-bottom: 24rpx;
      display: block;
    }

    .author-info {
      display: flex;
      justify-content: space-between;
      align-items: center;
      .author-left {
        display: flex;
        align-items: center;
        .author-avatar {
          font-size: 36rpx;
          margin-right: 12rpx;
        }
        .author-name {
          font-size: 28rpx;
          font-weight: 600;
          color: #475569;
        }
      }
      .post-date {
        font-size: 24rpx;
        color: #94a3b8;
      }
    }
  }

  .article-body {
    font-size: 30rpx;
    color: #334155;
    line-height: 1.8;
  }

  .interaction-bar {
    margin-top: 40rpx;
    padding-top: 30rpx;
    border-top: 1rpx solid #f1f5f9;
    display: flex;
    justify-content: flex-end;

    .fav-box {
      display: flex;
      align-items: center;
      background-color: #fff1f2;
      padding: 10rpx 24rpx;
      border-radius: 40rpx;

      .fav-icon {
        font-size: 32rpx;
        margin-right: 8rpx;
      }
      .fav-count {
        font-size: 24rpx;
        color: #e11d48;
        font-weight: bold;
      }
    }
  }
}

/* 3. Comments Area */
.comment-section {
  background-color: #ffffff;
  padding: 40rpx 30rpx;
  margin-bottom: 120rpx;

  .section-header {
    display: flex;
    align-items: center;
    margin-bottom: 40rpx;
    .section-title {
      font-size: 32rpx;
      font-weight: 800;
      color: #1e293b;
      margin-right: 12rpx;
    }
    .section-count {
      font-size: 26rpx;
      color: #94a3b8;
    }
  }
}

.comment-list {
  .comment-item {
    display: flex;
    margin-bottom: 40rpx;

    .user-icon {
      width: 64rpx;
      height: 64rpx;
      background-color: #f1f5f9;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32rpx;
      margin-right: 20rpx;
      flex-shrink: 0;
    }

    .comment-main {
      flex: 1;
      .comment-top {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8rpx;
        .user-name {
          font-size: 26rpx;
          font-weight: bold;
          color: #475569;
        }
        .comment-time {
          font-size: 22rpx;
          color: #cbd5e1;
        }
      }
      .comment-text {
        font-size: 28rpx;
        color: #334155;
        line-height: 1.5;
        background-color: #f8fafc;
        padding: 16rpx 24rpx;
        border-radius: 0 24rpx 24rpx 24rpx;
      }
    }
  }
}

.empty-comment {
  text-align: center;
  padding: 60rpx 0;
  .empty-icon { font-size: 60rpx; display: block; margin-bottom: 10rpx; opacity: 0.3;}
  .empty-text { font-size: 24rpx; color: #cbd5e1; }
}

/* 4. Bottom Input Bar */
.reply-box-wrapper {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background-color: #ffffff;
  padding: 20rpx 30rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  box-shadow: 0 -4rpx 20rpx rgba(0,0,0,0.05);
  z-index: 100;

  .reply-box-inner {
    display: flex;
    align-items: center;

    .send-btn {
      margin-left: 20rpx;
      background-color: #3b82f6;
      padding: 16rpx 36rpx;
      border-radius: 40rpx;

      .send-text {
        color: #ffffff;
        font-size: 26rpx;
        font-weight: bold;
      }

      &:active {
        opacity: 0.8;
      }
    }
  }
}

.safe-bottom-spacer {
  height: 140rpx;
}

/* Responsive Web Layout */
@media screen and (min-width: 768px) {
  .page-detail {
    max-width: 600px;
    margin: 0 auto;
    border-left: 1rpx solid #e2e8f0;
    border-right: 1rpx solid #e2e8f0;
  }
  .reply-box-wrapper {
    max-width: 600px;
    left: 50%;
    transform: translateX(-50%);
  }
}
</style>