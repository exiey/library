<!-- 自习室选座 - 现代空间化预约界面 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar
        title="自习室预约选座"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. 筛选条件卡片 -->
      <view class="filter-card">
        <view class="card-header">
          <text class="card-title">📅 预约设置</text>
          <text class="card-subtitle">请选择您心仪的时间和偏好</text>
        </view>

        <u--form labelPosition="left" :model="fobj" ref="fform" labelWidth="80">
          <!-- 自习室选择 -->
          <view class="custom-input-box">
            <ideaselect label="所在位置" showName="title" :datalist="[roomlist]" v-model="pobj"></ideaselect>
          </view>

          <!-- 偏好选择 -->
          <view class="custom-input-box">
            <ideaslc label="座位偏好" :datalist="[['全部','靠窗','靠过道','中间']]" v-model="note"></ideaslc>
          </view>

          <!-- 时段选择 -->
          <view class="custom-input-box">
            <ideaselect label="预约时段" showName="title" :datalist="[shiduanlist]" v-model="sobj"></ideaselect>
          </view>

          <!-- 日期选择 -->
          <view class="custom-input-box no-border">
            <ideadatetime mode="date" :minDate="Date.now()+86400000" v-model="riqi" label="预约日期"></ideadatetime>
          </view>
        </u--form>

        <view class="action-box">
          <u-button
              @click="refresh"
              class="query-btn"
              type="primary"
              text="查询实时余座"
              :customStyle="{ height: '90rpx', borderRadius: '20rpx', fontWeight: 'bold' }"
          ></u-button>
        </view>
      </view>

      <!-- 2. 选座区域 -->
      <view class="seat-section" v-if="datalist.length > 0">
        <view class="seat-header">
          <view class="title-group">
            <view class="title-line"></view>
            <text class="section-title">自习室平面图</text>
          </view>
          <!-- 图例说明 -->
          <view class="legend-group">
            <view class="legend-item">
              <view class="l-box available"></view>
              <text>可选</text>
            </view>
            <view class="legend-item">
              <view class="l-box occupied"></view>
              <text>已占</text>
            </view>
            <view class="legend-item">
              <view class="l-box maintenance"></view>
              <text>维修</text>
            </view>
          </view>
        </view>

        <!-- 座位网格容器 -->
        <view class="seat-grid-container">
          <view class="seat-grid">
            <view
                v-for="(item,index) in datalist"
                :key="index"
                @click="toggleZuowei(item.id)"
                :class="['seat-unit', item.class]"
            >
              <text class="seat-num">{{item.title}}</text>
              <text class="seat-icon">🪑</text>
            </view>
          </view>
        </view>

        <view class="seat-footer">
          <text>⚠️ 请准时到达，违规将扣除信誉分</text>
        </view>
      </view>

      <!-- 暂无数据提示 -->
      <view v-else class="empty-state">
        <text class="empty-icon">📍</text>
        <text class="empty-text">请先选择上方条件并点击查询</text>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, deletej, fileUrl } from '@/common/config/api.js';
import { mapState, mapActions } from 'vuex';
import imgList from '@/components/img-list.vue';

export default {
  components: { imgList },
  data() {
    return {
      datalist: [],
      note: '全部',
      fobj: {},
      pobj: {},
      sobj: {},
      shiduanlist: [],
      roomlist: [],
      zuoweilist: [],
      zobj: [],
      riqi: null,
      rid: null,
      txnote: null,
      paytotal: 10,
      fkms: '正常模式',
      site: null
    };
  },
  watch: {
    pobj: {
      immediate: false,
      deep: true,
      handler(news) {
        if(news && news.id) this.listZ(news.id)
      }
    }
  },
  onLoad(params) {
    this.rid = params.rid;
    this.listP();
    this.listS();
    if (this.rid) {
      findj({ params: { table: 'room', id: this.rid } }).then(res => {
        this.pobj = res;
      });
    }
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    toggleZuowei(id) {
      const item = this.datalist.find(d => d.id === id);
      if (item) {
        if (item.class === 'zuowei') {
          this.fobjDetail(id);
        } else if (item.class === 'zuoweim') {
          uni.showToast({ icon: 'none', title: '该位置正在维修中，暂不可用' });
        } else {
          // 跳转到占位人的个人资料
          uni.navigateTo({
            url: `/pages/me/userprofile?uid=${item.uid}`
          });
        }
      }
    },
    listZ(pid) {
      listj({ params: { table: 'site', pid: pid } }).then(res => {
        this.zuoweilist = res;
      });
    },
    listP() {
      listj({ params: { table: 'room' } }).then(res => {
        this.roomlist = res;
      });
    },
    listS() {
      listj({ params: { table: 'shiduan' } }).then(res => {
        this.shiduanlist = res;
      });
    },
    refresh() {
      if (this.pobj.id && this.sobj.id && this.riqi) {
        findj({ params: { table: 'yuyue', ydate: this.riqi, shiduanid: this.sobj.id, uid: this.userInfo.id } }).then(res => {
          if (res) {
            uni.showModal({ title: "提示", content: "您已预约过此时段，不能重复预约", showCancel: false });
          } else {
            let searchNote = this.note === '全部' ? null : this.note;
            listj({ params: { table: 'site', pid: this.pobj.id, note: searchNote } }).then(slist => {
              slist = slist || [];
              listj({ params: { table: 'yuyue', ydate: this.riqi, shiduanid: this.sobj.id, statecn: '已预约' } }).then(ylist => {
                ylist = ylist || [];
                let list = [];
                for (let s of slist) {
                  const reservation = ylist.find(y => y.siteid == s.id);
                  let yflag = !!reservation;
                  if (s.statecn === '维修中') {
                    s.statecn_display = '维修中';
                    s.class = 'zuoweim';
                  } else if (yflag) {
                    s.statecn_display = '已占用';
                    s.class = 'zuoweif';
                    s.uid = reservation.uid; // 保存占位人 UID
                  } else {
                    s.statecn_display = '可申请';
                    s.class = 'zuowei';
                  }
                  list.push(s);
                }
                // 疫情防控模式逻辑保留
                if (this.fkms === '疫情防控模式') {
                  this.datalist = list.filter((_, i) => i % 2 === 0);
                } else {
                  this.datalist = list;
                }
              });
            });
          }
        });
      } else {
        uni.showToast({ icon: 'none', title: '请完善预约信息' });
      }
    },
    fobjDetail(id) {
      findj({ params: { table: 'site', id: id } }).then(site => {
        this.site = site;
        
        // 计算预计积分
        let estMinutes = 0;
        if (this.sobj.title) {
          const times = this.sobj.title.split('-');
          if (times.length === 2) {
            const s = times[0].split(':');
            const e = times[1].split(':');
            const startMin = parseInt(s[0]) * 60 + parseInt(s[1]);
            const endMin = parseInt(e[0]) * 60 + parseInt(e[1]);
            estMinutes = endMin - startMin;
          }
        }

        uni.showModal({
          title: "确认预约",
          content: `自习室: ${this.pobj.title}\n座位号: ${site.title}\n时间: ${this.riqi} ${this.sobj.title}\n预计获得: ${estMinutes} 积分`,
          success: (res) => {
            if (res.confirm) this.payBill();
          }
        });
      });
    },
    yuyueCommit() {
      let fdata = {
        ydate: this.riqi,
        site: this.site.title,
        siteid: this.site.id,
        shiduanid: this.sobj.id,
        shiduan: this.sobj.title,
        room: this.pobj.title,
        roomid: this.pobj.id,
        username: this.userInfo.username,
        uid: this.userInfo.id,
        statecn: "已预约",
        tel: this.userInfo.tel,
        table: "yuyue",
        total: this.pobj.total || 0
      };
      savej({ params: fdata }).then(() => {
        uni.showToast({ title: '预约成功' });
        setTimeout(() => {
          uni.switchTab({ url: '/pages/yuyue/yuyue' });
        }, 1500);
      });
    },
    payBill() {
      let mymoney = (this.userInfo.money || 0) * 1;
      if (mymoney < this.paytotal) {
        uni.showToast({ icon: 'none', title: '余额不足，正尝试预约...' });
        setTimeout(() => this.yuyueCommit(), 1500);
      } else {
        mymoney -= this.paytotal;
        savej({ params: { table: 'user', id: this.userInfo.id, money: mymoney } }).then(() => {
          this.userInfo.money = mymoney;
          this.updateUserInfo(this.userInfo);
          this.yuyueCommit();
        });
      }
    },
    goBack() {
      uni.switchTab({ url: '/pages/index/index' });
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
  background-color: #f6f8fb;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 筛选卡片 */
.filter-card {
  margin: 24rpx;
  padding: 30rpx;
  background-color: #ffffff;
  border-radius: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.03);
}

.card-header {
  margin-bottom: 30rpx;
  border-bottom: 1rpx solid #f0f0f0;
  padding-bottom: 20rpx;
}

.card-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  display: block;
}

.card-subtitle {
  font-size: 22rpx;
  color: #999;
}

.custom-input-box {
  border-bottom: 1rpx solid #f8f8f8;
  padding: 10rpx 0;
}

.no-border {
  border-bottom: none;
}

.action-box {
  margin-top: 30rpx;
}

/* 选座区域 */
.seat-section {
  margin: 24rpx;
  padding: 30rpx;
  background-color: #ffffff;
  border-radius: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.03);
}

.seat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 40rpx;
}

.title-group {
  display: flex;
  align-items: center;
}

.title-line {
  width: 8rpx;
  height: 32rpx;
  background: #4facfe;
  border-radius: 4rpx;
  margin-right: 16rpx;
}

.section-title {
  font-size: 30rpx;
  font-weight: bold;
}

.legend-group {
  display: flex;
  gap: 20rpx;
}

.legend-item {
  display: flex;
  align-items: center;
  font-size: 22rpx;
  color: #666;
}

.l-box {
  width: 24rpx;
  height: 24rpx;
  border-radius: 6rpx;
  margin-right: 8rpx;
}

.l-box.available { background-color: #ecfdf5; border: 1rpx solid #10b981; }
.l-box.occupied { background-color: #fef2f2; border: 1rpx solid #ef4444; }
.l-box.maintenance { background-color: #f1f5f9; border: 1rpx solid #94a3b8; }

/* 座位网格实现 */
.seat-grid-container {
  padding: 20rpx 0;
}

.seat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* 4列响应式 */
  gap: 24rpx;
}

.seat-unit {
  height: 120rpx;
  border-radius: 20rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  position: relative;
}

.seat-unit:active {
  transform: scale(0.9);
}

.seat-num {
  font-size: 24rpx;
  font-weight: bold;
  margin-bottom: 4rpx;
  z-index: 2;
}

.seat-icon {
  font-size: 32rpx;
  opacity: 0.5;
}

/* 座位状态类 */
.zuowei {
  background-color: #ecfdf5;
  border: 2rpx solid #10b981;
  color: #059669;
}

.zuoweif {
  background-color: #fef2f2;
  border: 2rpx solid #ef4444;
  color: #dc2626;
}

.zuoweim {
  background-color: #f1f5f9;
  border: 2rpx solid #94a3b8;
  color: #64748b;
}

.seat-footer {
  margin-top: 40rpx;
  text-align: center;
  font-size: 22rpx;
  color: #ff9d00;
  background-color: #fff9eb;
  padding: 16rpx;
  border-radius: 12rpx;
}

/* 空状态 */
.empty-state {
  padding: 100rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.empty-icon { font-size: 80rpx; margin-bottom: 20rpx; }
.empty-text { color: #999; font-size: 26rpx; }

.safe-bottom { height: 60rpx; }

/* 跨端 Web 适配 */
@media screen and (min-width: 750px) {
  .seat-grid {
    grid-template-columns: repeat(6, 1fr); /* 宽屏显示6列 */
  }
  .content-scroll {
    max-width: 600px;
    margin: 0 auto;
  }
}
</style>