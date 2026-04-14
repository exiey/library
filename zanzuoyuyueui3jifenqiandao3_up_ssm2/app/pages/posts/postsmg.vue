<template>
  <view class="edit-page">
    <!-- 导航栏：风格统一，加重标题字重 -->
    <u-navbar
        title="发布内容"
        :border="false"
        :placeholder="true"
        :autoBack="true"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #1a1a1a;"
    ></u-navbar>

    <scroll-view :enable-flex="true" scroll-y class="svcontainer">
      <view class="content-wrapper">
        <!-- 顶部提示 -->
        <view class="info-header">
          <text class="info-title">填写详情</text>
          <text class="info-desc">请完善以下信息，让内容更有吸引力 ✨</text>
        </view>

        <!-- 表单主卡片 -->
        <view class="form-card">
          <!-- 标题输入 -->
          <view class="form-group">
            <view class="label-box">
              <text class="icon">🏷️</text>
              <text class="label-text">文章标题</text>
            </view>
            <input
                type="text"
                v-model="fobj.title"
                class="custom-input"
                placeholder="请输入吸引人的标题..."
                placeholder-class="ph-style"
            />
          </view>

          <!-- 文件上传 -->
          <view class="form-group">
            <view class="label-box">
              <text class="icon">📎</text>
              <text class="label-text">上传封面/附件</text>
            </view>
            <view class="upload-container">
              <fileUpload v-model="sfileName"></fileUpload>
            </view>
          </view>

          <!-- 富文本编辑器 -->
          <view class="form-group no-border">
            <view class="label-box">
              <text class="icon">📝</text>
              <text class="label-text">详细信息</text>
            </view>
            <view class="editor-wrapper">
              <jinEdit
                  :html="editorHtml"
                  @getEditorContxt="getEditorContxt"
                  v-model="fobj.note"
                  height="400px"
                  :uploadFileUrl="uploadUrl"
                  placeholder="写下你想分享的故事..."
                  @editOk="editOk"
              ></jinEdit>
            </view>
          </view>
        </view>

        <!-- 操作按钮区 -->
        <view class="footer-actions">
          <view class="btn-submit" @click="savePosts()">
            <text class="btn-text">🚀 立即提交</text>
          </view>

          <view v-if="tid" class="btn-delete" @click="delPosts()">
            <text class="btn-text">🗑️ 删除内容</text>
          </view>
        </view>
      </view>

      <!-- 底部适配 -->
      <view class="safe-area-inset-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import {
  listj,
  findj,
  savej,
  deletej,
  fileUrl,
  uploadUrl
} from '@/common/config/api.js';
import {
  mapState,
  mapActions
} from 'vuex';
import jinEdit from '@/components/jin-edit/jin-edit.vue';
import ideaUpload from '@/components/idea-upload/idea-upload.vue';
import fileUpload from '@/components/file-upload.vue';
import { ideautil, yewuutil } from '@/common/commontools.js'

export default {
  components: {
    jinEdit,
    fileUpload,
    ideaUpload
  },
  data() {
    return {
      tel: '',
      typelist: [],
      filelist: [],
      sfileName: '', // 绑定fileUpload
      fobj: {
        title: '',
        type: 1,
        note: '',
        img: '',
        table: 'posts'
      },
      tid: null,
      fileUrl: fileUrl,
      uploadUrl: uploadUrl,
      editorCtx:null,
      editorHtml:'',
      totype:1
    };
  },
  onLoad(params) {
    if (params.tid && params.tid !== 'undefined') {
      this.tid = params.tid
    }
    this.totype = params.totype || 1

    if (this.tid) {
      findj({
        params: {
          table: 'posts',
          id: this.tid
        }
      }).then(res => {
        this.fobj = res
        if(res.img) {
          this.filelist.push({url: this.fileUrl + res.img})
          this.sfileName = res.img; // 同步给组件
        }
        this.editorHtml = this.fobj.note
      }).catch(err => {
        console.error(err)
      })
    }

    listj({
      params: { table: 'type2' }
    }).then(res => {
      this.typelist = res
    }).catch(err => {
      console.error(err)
    })
  },
  methods: {
    savePosts() {
      if(!this.fobj.title) {
        uni.showToast({ title: '标题不能为空', icon: 'none' });
        return;
      }

      this.editorCtx.getContents({
        success: res => {
          this.fobj.note = res.html
          this.fobj.uid = this.userInfo.id
          this.fobj.username = this.userInfo.username

          // 处理图片/文件逻辑，保持原逻辑不变
          if(this.filelist.length > 0) {
            this.fobj.img = this.filelist[0].url.data || this.fobj.img
          }

          let fdata = this.fobj
          fdata.table = "posts"
          savej({
            params: fdata
          }).then(res => {
            uni.showToast({ title: '保存成功' });
            setTimeout(() => {
              if (this.totype==1) {
                uni.redirectTo({ url: './posts?type='+this.fobj.type+'&uid='+this.userInfo.id })
              }else{
                uni.redirectTo({ url: './postslist?type='+this.fobj.type+'&uid='+this.userInfo.id })
              }
            }, 1000);
          })
        }
      })
    },
    delPosts() {
      uni.showModal({
        title: '确认删除',
        content: '内容删除后不可恢复，确定吗？',
        confirmColor: '#ff4d4f',
        success: (res) => {
          if (res.confirm) {
            deletej({
              params: { table: 'posts', id: this.tid }
            }).then(res => {
              uni.redirectTo({ url: './posts' })
            })
          }
        }
      })
    },
    editOk(res) {
      this.fobj.note = res.html
    },
    getEditorContxt(ctx){
      this.editorCtx = ctx
      this.editorCtx.setContents({
        html: this.fobj.note
      })
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
.edit-page {
  background-color: #f4f7f9;
  min-height: 100vh;
}

.svcontainer {
  height: calc(100vh - 44px);
}

.content-wrapper {
  padding: 30rpx;
  /* Web端在大屏下的显示优化 */
  max-width: 800px;
  margin: 0 auto;
}

.info-header {
  margin-bottom: 40rpx;
  padding-left: 10rpx;

  .info-title {
    font-size: 36rpx;
    font-weight: 800;
    color: #334155;
    display: block;
  }
  .info-desc {
    font-size: 24rpx;
    color: #94a3b8;
    margin-top: 8rpx;
    display: block;
  }
}

/* 卡片式表单样式 */
.form-card {
  background-color: #ffffff;
  border-radius: 32rpx;
  padding: 20rpx 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.03);
  margin-bottom: 40rpx;

  .form-group {
    padding: 30rpx 0;
    border-bottom: 1px solid #f1f5f9;

    &:last-child {
      border-bottom: none;
    }

    &.no-border {
      border-bottom: none;
    }

    .label-box {
      display: flex;
      align-items: center;
      margin-bottom: 20rpx;

      .icon {
        font-size: 32rpx;
        margin-right: 12rpx;
      }
      .label-text {
        font-size: 28rpx;
        font-weight: 600;
        color: #475569;
      }
    }
  }
}

/* 输入控件美化 */
.custom-input {
  height: 88rpx;
  background-color: #f8fafc;
  border-radius: 16rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  color: #1e293b;
  border: 1px solid transparent;
  transition: all 0.3s ease;

  &:focus {
    background-color: #ffffff;
    border-color: #3b82f6;
  }
}

.ph-style {
  color: #cbd5e1;
}

/* 编辑器容器 */
.editor-wrapper {
  border: 2rpx solid #e2e8f0;
  border-radius: 16rpx;
  overflow: hidden;
  background-color: #ffffff;
}

/* 按钮样式 */
.footer-actions {
  margin-top: 60rpx;
  padding-bottom: 40rpx;

  .btn-submit {
    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
    height: 100rpx;
    border-radius: 50rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10rpx 20rpx rgba(37, 99, 235, 0.2);
    transition: transform 0.2s;

    &:active {
      transform: scale(0.98);
    }

    .btn-text {
      color: #ffffff;
      font-size: 32rpx;
      font-weight: bold;
    }
  }

  .btn-delete {
    margin-top: 30rpx;
    height: 90rpx;
    border-radius: 50rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2rpx solid #fee2e2;
    background-color: #fff1f0;

    &:active {
      background-color: #fecaca;
    }

    .btn-text {
      color: #ef4444;
      font-size: 28rpx;
      font-weight: 500;
    }
  }
}

.safe-area-inset-bottom {
  height: env(safe-area-inset-bottom);
}
</style>