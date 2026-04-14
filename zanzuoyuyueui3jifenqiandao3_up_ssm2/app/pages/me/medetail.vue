<!-- 个人信息编辑 - 蓝色现代风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        title="个人信息"
        :border="false"
        :placeholder="true"
        :autoBack="true"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 头像上传区 -->
      <view class="avatar-section">
        <view class="avatar-card shadow-blur">
          <view class="upload-wrapper">
            <ideaUpload v-model="filelist"></ideaUpload>
            <view class="edit-badge">📸</view>
          </view>
          <!-- #ifdef MP-WEIXIN -->
          <button class="wx-avatar-btn" open-type="chooseAvatar" @chooseavatar="getWxAvatar">
            <text class="btn-icon">💬</text> 使用微信头像
          </button>
          <!-- #endif -->
          <text class="upload-tip">点击上方图标或按钮更换头像</text>
        </view>
      </view>

      <!-- 2. 信息填写表单 -->
      <view class="form-card shadow-sm">
        <view class="form-group">
          <text class="group-title">👤 基本账号</text>

          <view class="input-item">
            <text class="label">用户名</text>
            <input
                id="nickname-input"
                @blur="setNickName"
                type="nickname"
                v-model="fobj.username"
                placeholder="建议使用常用昵称"
                class="custom-input"
            />
          </view>

          <view class="input-item">
            <text class="label">真实姓名</text>
            <input
                type="text"
                v-model="fobj.fname"
                placeholder="请输入您的姓名"
                class="custom-input"
            />
          </view>
        </view>

        <view class="form-group">
          <text class="group-title">📞 通讯与安全</text>

          <view class="input-item">
            <text class="label">手机号码</text>
            <input
                type="tel"
                v-model="fobj.tel"
                placeholder="请输入11位手机号"
                class="custom-input"
            />
          </view>

          <view class="input-item">
            <text class="label">登录密码</text>
            <input
                type="password"
                v-model="fobj.passwd"
                placeholder="设置您的新密码"
                class="custom-input"
            />
          </view>
        </view>

        <view class="form-group no-border">
          <text class="group-title">🚻 性别设置</text>
          <view class="sex-selector">
            <radio-group @change="showSex" class="custom-radio-group">
              <label class="radio-label" :class="{active: fobj.sex === '男'}">
                <radio value="男" :checked="fobj.sex=='男'" color="#4facfe" />
                <text class="sex-text">男生</text>
              </label>
              <label class="radio-label" :class="{active: fobj.sex === '女'}">
                <radio value="女" :checked="fobj.sex=='女'" color="#4facfe" />
                <text class="sex-text">女生</text>
              </label>
            </radio-group>
          </view>
        </view>
      </view>

      <!-- 3. 提交按钮 -->
      <view class="footer-action">
        <button class="submit-btn" @click="updateInfo()">保存更改</button>
        <text class="footer-tip">个人信息将用于自习室实名认证，请如实填写</text>
      </view>

      <view class="safe-bottom-pad"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, fileUrl, saveWxUser, uploadUrl } from '@/common/config/api.js'
import { mapState, mapActions } from 'vuex'
import ideaUpload from '@/components/idea-upload/idea-upload.vue'

export default {
  components: { ideaUpload },
  data() {
    return {
      fobj: {},
      filelist: [],
      fileUrl: fileUrl,
      uploadUrl: uploadUrl,
      nickname: ''
    }
  },
  onLoad(params) {
    // 深拷贝防止污染
    this.fobj = JSON.parse(JSON.stringify(this.userInfo))
    if (this.fobj.img) {
      setTimeout(() => {
        this.filelist.push({ url: this.fileUrl + this.fobj.img })
      }, 100)
    }
  },
  methods: {
    ...mapActions(['updateUserInfo']),

    getWxAvatar(e) {
      let imgurl = e.detail.avatarUrl
      uni.showLoading({ title: '上传中...' })
      uni.uploadFile({
        url: this.uploadUrl,
        filePath: imgurl,
        name: 'file',
        success: (res) => {
          let img = res.data
          this.fobj.img = img
          this.filelist = [{ url: this.fileUrl + img, fileName: img }]
          uni.hideLoading()
        },
        fail: () => uni.hideLoading()
      });
    },

    showSex(v) {
      this.fobj.sex = v.detail.value
    },

    setNickName(event) {
      uni.createSelectorQuery().in(this)
          .select("#nickname-input")
          .fields({ properties: ["value"] })
          .exec((res) => {
            const nickName = res?.[0]?.value
            if (nickName) {
              this.fobj.username = nickName
              findj({ params: { table: 'user', username: nickName } }).then(exist => {
                if (exist && exist.id != this.userInfo.id) {
                  uni.showToast({ icon: 'none', title: '用户名已存在' })
                  this.fobj.username = ""
                }
              })
            }
          })
    },

    updateInfo() {
      if (!this.fobj.username || !this.fobj.tel) {
        uni.showToast({ icon: 'none', title: '请填写昵称和电话' });
        return;
      }

      uni.showLoading({ title: '保存中...' })
      this.fobj.table = 'user'
      if (this.filelist.length > 0) {
        this.fobj.img = this.filelist[0].fileName || this.fobj.img
      }

      savej({ params: this.fobj }).then(() => {
        uni.hideLoading()
        this.updateUserInfo(this.fobj)
        uni.showToast({ title: '已保存', icon: 'success' })
        setTimeout(() => uni.navigateBack(), 1500)
      }).catch(() => uni.hideLoading())
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

/* 头像区域 */
.avatar-section {
  padding: 40rpx 32rpx;
  display: flex;
  justify-content: center;
}

.avatar-card {
  background-color: #ffffff;
  padding: 40rpx;
  border-radius: 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
}

.upload-wrapper {
  position: relative;
  margin-bottom: 30rpx;
  ::v-deep .u-upload { justify-content: center; }
}

.edit-badge {
  position: absolute;
  right: -10rpx;
  bottom: -10rpx;
  background-color: #4facfe;
  width: 50rpx;
  height: 50rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 4rpx solid #fff;
  font-size: 24rpx;
}

.wx-avatar-btn {
  background-color: #f0fdf4;
  color: #16a34a;
  font-size: 26rpx;
  border-radius: 100rpx;
  padding: 0 40rpx;
  height: 70rpx;
  line-height: 70rpx;
  border: 1rpx solid #dcfce7;
  display: flex;
  align-items: center;
  &::after { border: none; }
  .btn-icon { margin-right: 10rpx; }
}

.upload-tip {
  font-size: 22rpx;
  color: #94a3b8;
  margin-top: 20rpx;
}

/* 表单卡片 */
.form-card {
  background-color: #ffffff;
  margin: 0 32rpx 40rpx;
  border-radius: 32rpx;
  padding: 10rpx 40rpx;
}

.form-group {
  padding: 30rpx 0;
  border-bottom: 1rpx solid #f1f5f9;
}
.no-border { border-bottom: none; }

.group-title {
  font-size: 24rpx;
  font-weight: bold;
  color: #94a3b8;
  margin-bottom: 30rpx;
  display: block;
}

.input-item { margin-bottom: 30rpx; }

.label {
  font-size: 28rpx;
  color: #475569;
  margin-bottom: 12rpx;
  display: block;
}

.custom-input {
  height: 84rpx;
  background-color: #f8fafc;
  border-radius: 16rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  border: 1rpx solid #f1f5f9;
}

/* 性别选择器 */
.custom-radio-group {
  display: flex;
  gap: 30rpx;
}

.radio-label {
  flex: 1;
  height: 90rpx;
  background-color: #f8fafc;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid transparent;
  transition: all 0.2s;

  &.active {
    background-color: #f0f7ff;
    border-color: #4facfe;
    .sex-text { color: #4facfe; font-weight: bold; }
  }

  radio { transform: scale(0.8); margin-right: 10rpx; }
  .sex-text { font-size: 28rpx; color: #64748b; }
}

/* 底部按钮 */
.footer-action {
  padding: 20rpx 32rpx;
  text-align: center;
}

.submit-btn {
  background: linear-gradient(to right, #4facfe, #00b4db);
  color: white;
  height: 100rpx;
  line-height: 100rpx;
  border-radius: 24rpx;
  font-size: 32rpx;
  font-weight: bold;
  border: none;
  box-shadow: 0 10rpx 20rpx rgba(79, 172, 254, 0.2);
  &:active { opacity: 0.9; transform: scale(0.99); }
}

.footer-tip {
  font-size: 22rpx;
  color: #cbd5e1;
  margin-top: 24rpx;
  display: block;
}

.safe-bottom-pad { height: 60rpx; }
.shadow-blur { box-shadow: 0 10rpx 40rpx rgba(0,0,0,0.03); }
.shadow-sm { box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.02); }

@media screen and (min-width: 750px) {
  .content-scroll { max-width: 500px; margin: 0 auto; }
}
</style>