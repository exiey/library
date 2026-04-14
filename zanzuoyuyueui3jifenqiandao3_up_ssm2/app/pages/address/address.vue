<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        :title="showEdit ? (fobj.id ? '编辑联系人' : '新增联系人') : '联系人管理'"
        :border="false"
        :placeholder="true"
        :rightText="showEdit ? '✖️' : '➕'"
        @rightClick="handleRightClick"
        @leftClick="handleBack"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 模式一：联系人列表 -->
      <view v-if="!showEdit" class="list-mode animate-fade-in">
        <view class="search-header">
          <text class="count-text">共 {{ fobjList.length }} 位联系人</text>
        </view>

        <view class="contact-list">
          <view
              class="contact-card shadow-sm"
              v-for="(item, index) in fobjList"
              :key="index"
              @tap="toEdit(item)"
              hover-class="card-hover"
          >
            <view class="contact-avatar">
              <text>{{ getFirstChar(item.lxr) }}</text>
            </view>
            <view class="contact-info">
              <view class="info-top">
                <text class="contact-name">{{ item.lxr }}</text>
                <text class="contact-tel">{{ item.tel }}</text>
              </view>
              <view class="info-bottom">
                <text class="loc-icon">📍</text>
                <text class="contact-addr">{{ item.address }}</text>
              </view>
            </view>
            <text class="edit-btn-icon">✎</text>
          </view>
        </view>

        <view v-if="fobjList.length === 0" class="empty-box">
          <text class="empty-emoji">👤</text>
          <text class="empty-text">暂无联系人，请点击右上角新增</text>
        </view>
      </view>

      <!-- 模式二：表单编辑 -->
      <view v-else class="edit-mode animate-slide-up">
        <view class="form-card shadow-lg">
          <view class="form-header">
            <view class="title-line"></view>
            <text class="form-title">基本信息</text>
          </view>

          <!-- 改用 u--input 以获得更好的多端双向绑定支持 -->
          <view class="input-group">
            <text class="label">姓名</text>
            <u--input
                placeholder="请输入联系人姓名"
                border="bottom"
                v-model="fobj.lxr"
                clearable
            ></u--input>
          </view>

          <view class="input-group">
            <text class="label">电话</text>
            <u--input
                placeholder="请输入电话号码"
                border="bottom"
                type="number"
                v-model="fobj.tel"
                clearable
            ></u--input>
          </view>

          <view class="input-group">
            <text class="label">详细地址</text>
            <u--textarea
                v-model="fobj.address"
                placeholder="请输入详细地址"
                count
                autoHeight
            ></u--textarea>
          </view>

          <view class="button-row">
            <u-button
                text="保存信息"
                type="primary"
                shape="circle"
                @click="saveAddress"
                customStyle="background: linear-gradient(to right, #4facfe, #00b4db); border: none; height: 90rpx;"
            ></u-button>
            <u-button
                v-if="fobj.id"
                text="删除联系人"
                type="error"
                plain
                shape="circle"
                @click="delAddress"
                customStyle="margin-top: 20rpx; height: 90rpx;"
            ></u-button>
          </view>
        </view>
      </view>

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
      showEdit: false,
      fobjList: [],
      // 必须完整声明
      fobj: {
        lxr: '',
        tel: '',
        address: '',
        id: null,
        table: 'address'
      }
    };
  },
  onLoad() {
    this.fetchList();
  },
  methods: {
    fetchList() {
      uni.showLoading({ title: '加载中' });
      listj({ params: { table: 'address', uid: this.userInfo.id } }).then(res => {
        this.fobjList = (res || []).map(item => {
          const parts = (item.title || "").split(' ');
          return {
            ...item,
            lxr: parts[0] || '',
            tel: parts[1] || '',
            address: parts[2] || ''
          };
        });
        uni.hideLoading();
      }).catch(() => uni.hideLoading());
    },

    handleRightClick() {
      if (this.showEdit) {
        this.showEdit = false;
      } else {
        this.toAdd();
      }
    },

    toAdd() {
      // 修复方案：不整体替换对象引用，而是重置属性
      this.fobj.lxr = '';
      this.fobj.tel = '';
      this.fobj.address = '';
      this.fobj.id = null;
      this.fobj.table = 'address';
      this.showEdit = true;
    },

    toEdit(item) {
      // 修复方案：确保数据能回显到双向绑定中
      this.fobj.id = item.id;
      this.fobj.lxr = item.lxr;
      this.fobj.tel = item.tel;
      this.fobj.address = item.address;
      this.fobj.table = 'address';
      this.showEdit = true;
    },

    saveAddress() {
      if (!this.fobj.lxr || !this.fobj.tel) {
        uni.showToast({ title: '姓名和电话必填', icon: 'none' });
        return;
      }

      // 还原存储逻辑：拼接 title
      const combinedTitle = `${this.fobj.lxr} ${this.fobj.tel} ${this.fobj.address}`;

      const params = {
        table: 'address',
        id: this.fobj.id,
        uid: this.userInfo.id,
        title: combinedTitle
      };

      uni.showLoading({ title: '保存中' });
      savej({ params: params }).then(res => {
        uni.hideLoading();
        uni.showToast({ title: '已保存' });
        this.showEdit = false;
        this.fetchList();
      }).catch(() => uni.hideLoading());
    },

    delAddress() {
      uni.showModal({
        title: '提示',
        content: '确定删除该联系人吗？',
        success: (res) => {
          if (res.confirm) {
            deletej({ params: { table: 'address', id: this.fobj.id } }).then(() => {
              this.showEdit = false;
              this.fetchList();
            });
          }
        }
      });
    },

    handleBack() {
      if (this.showEdit) {
        this.showEdit = false;
      } else {
        uni.navigateBack();
      }
    },

    getFirstChar(name) {
      return name ? name.charAt(0).toUpperCase() : '?';
    },
  },
  computed: {
    ...mapState(['userInfo'])
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f7f9fc;
}
.content-scroll { height: calc(100vh - 44px); }

/* 列表态 */
.search-header { padding: 30rpx 40rpx 10rpx; }
.count-text { font-size: 24rpx; color: #94a3b8; }
.contact-list { padding: 20rpx 30rpx; }
.contact-card {
  background-color: #ffffff;
  border-radius: 28rpx;
  padding: 30rpx;
  margin-bottom: 24rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.02);
}
.contact-avatar {
  width: 90rpx; height: 90rpx;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-size: 36rpx; font-weight: bold; margin-right: 24rpx;
}
.contact-info { flex: 1; }
.contact-name { font-size: 32rpx; font-weight: bold; color: #1e293b; margin-right: 16rpx; }
.contact-tel { font-size: 24rpx; color: #64748b; }
.contact-addr { font-size: 24rpx; color: #94a3b8; display: block; margin-top: 6rpx; }

/* 编辑态 */
.edit-mode { padding: 30rpx; }
.form-card { background: #fff; border-radius: 32rpx; padding: 40rpx; }
.form-header { display: flex; align-items: center; margin-bottom: 40rpx; }
.title-line { width: 8rpx; height: 32rpx; background: #4facfe; border-radius: 4rpx; margin-right: 16rpx; }
.form-title { font-size: 32rpx; font-weight: bold; }

.input-group { margin-bottom: 40rpx; }
.label { font-size: 26rpx; color: #64748b; margin-bottom: 16rpx; display: block; }

.button-row { margin-top: 60rpx; }

.animate-fade-in { animation: fadeIn 0.3s; }
.animate-slide-up { animation: slideUp 0.3s; }
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { transform: translateY(20rpx); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

.empty-box { padding: 150rpx 0; display: flex; flex-direction: column; align-items: center; }
.empty-emoji { font-size: 100rpx; margin-bottom: 20rpx; opacity: 0.5; }
.empty-text { font-size: 26rpx; color: #94a3b8; }
.safe-bottom { height: 60rpx; }
</style>