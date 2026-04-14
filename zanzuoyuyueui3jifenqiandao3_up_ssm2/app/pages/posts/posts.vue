<template>
  <view class="page-container">
    <!-- 自定义导航栏：强化“新增”动作的视觉引导 -->
    <u-navbar
        title="社区帖子"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    >
      <view slot="right" class="nav-right-btn" @click="postsMg('')">
        <text class="plus-icon">➕</text>
        <text>发布</text>
      </view>
    </u-navbar>

    <scroll-view :enable-flex="true" scroll-y class="svcontainer">
      <!-- 顶部欢迎语/统计区 -->
      <view class="hero-section">
        <view class="welcome-box">
          <text class="title">发现新鲜事 🌟</text>
          <text class="subtitle">共 {{ fobjList.length }} 条动态正在讨论中</text>
        </view>
      </view>

      <!-- 列表容器 -->
      <view class="list-container">
        <block v-if="fobjList.length > 0">
          <!-- 使用 ::v-deep 在 style 中美化内部组件样式 -->
          <view class="styled-list">
            <imglist
                :imgSize="2"
                titleName="title"
                @clickItem='toPostsDetail'
                :dataList="fobjList"
                tName="username"
                sName='ndate'
            ></imglist>
          </view>
        </block>

        <!-- 空状态展现 -->
        <view v-else class="empty-box">
          <text class="empty-emoji">🏜️</text>
          <text class="empty-text">这里空空如也，快来占个沙发吧</text>
          <view class="empty-btn" @click="postsMg('')">去发帖</view>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="footer-spacer"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listSqlj, listj, findj, savej, fileUrl } from '@/common/config/api.js';
import {mapState, mapActions} from 'vuex';
import imgList from '@/components/img-list.vue';
import blogList from '@/components/blog-list.vue';
import { ideautil, yewuutil } from '@/common/commontools.js';

export default {
  components: {
    imgList,
    blogList
  },
  data() {
    return {
      fobjList: [],
      ftype: 1
    };
  },
  onLoad(params) {
    this.ftype = params.type || 1
    this.fetchList();
  },
  onShow() {
    // 如果需要返回刷新，可以取消注释
    // this.fetchList();
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    fetchList() {
      listj({
        params: {
          table: "posts",
          type: this.ftype
        }
      }).then(res => {
        this.fobjList = res || []
      }).catch(err => {
        console.error(err)
      })
    },
    toPostsDetail(id){
      uni.redirectTo({
        url:'/pages/posts/postsdetail?id=' + id
      })
    },
    postsMg(id){
      console.log("------------------>:aid:"+id)
      uni.redirectTo({
        url:'./postsmg?totype=1&tid=' + (id || '')
      })
    },
    goBack(){
      uni.switchTab({
        url:'/pages/me/me'
      })
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
/* 页面背景 */
.page-container {
  background-color: #f1f5f9;
  min-height: 100vh;
}

/* 导航栏右侧按钮自定义 */
.nav-right-btn {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: #ffffff;
  padding: 10rpx 24rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 12rpx rgba(37, 99, 235, 0.2);

  &:active {
    opacity: 0.8;
  }

  .plus-icon {
    font-size: 20rpx;
    margin-right: 6rpx;
  }
}

.svcontainer {
  height: calc(100vh - 44px);
}

/* Hero 引导区域 */
.hero-section {
  padding: 40rpx 30rpx;
  background-color: #ffffff;
  border-bottom: 1rpx solid #e2e8f0;
  margin-bottom: 20rpx;

  .welcome-box {
    .title {
      font-size: 40rpx;
      font-weight: 800;
      color: #1e293b;
      display: block;
    }
    .subtitle {
      font-size: 24rpx;
      color: #64748b;
      margin-top: 10rpx;
      display: block;
    }
  }
}

/* 列表容器美化 */
.list-container {
  padding: 0 20rpx;
}

/* 穿透修改内部组件样式，增加卡片质感 */
.styled-list {
  ::v-deep .imglist-item {
    background-color: #ffffff !important;
    border-radius: 24rpx !important;
    margin-bottom: 24rpx !important;
    padding: 20rpx !important;
    box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.03) !important;
    border: none !important;

    /* 针对标题字体的优化 */
    .title {
      font-size: 30rpx !important;
      font-weight: 600 !important;
      color: #1e293b !important;
    }

    /* 针对副标题/时间的优化 */
    .desc {
      color: #94a3b8 !important;
      font-size: 24rpx !important;
    }
  }
}

/* 空状态 */
.empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

  .empty-emoji {
    font-size: 120rpx;
    margin-bottom: 30rpx;
  }

  .empty-text {
    font-size: 28rpx;
    color: #94a3b8;
    margin-bottom: 40rpx;
  }

  .empty-btn {
    background-color: #3b82f6;
    color: white;
    padding: 16rpx 60rpx;
    border-radius: 40rpx;
    font-size: 28rpx;
    box-shadow: 0 8rpx 16rpx rgba(59, 130, 246, 0.2);
  }
}

.footer-spacer {
  height: 40rpx;
}

/* 多端适配 - Web 模式限制宽度 */
@media screen and (min-width: 768px) {
  .page-container {
    max-width: 600px;
    margin: 0 auto;
    box-shadow: 0 0 40rpx rgba(0,0,0,0.05);
  }

  .svcontainer {
    /* 针对PC端可能没有滚动条的情况优化 */
    overflow-y: auto;
  }
}
</style>