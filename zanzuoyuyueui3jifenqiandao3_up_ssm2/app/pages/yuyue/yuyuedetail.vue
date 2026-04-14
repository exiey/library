<!-- 预约详情 - 蓝色现代政务/商务风格 -->
<template>
  <view class="page-container">
    <!-- 导航栏 -->
    <u-navbar title="预约详情" :border="false" :placeholder="true" @leftClick="goBack" :autoBack="false" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>

    <scroll-view scroll-y class="content-scroll">
      <!-- 1. Status Header with Dynamic Class Mapping -->
      <view class="status-header" :class="statusClassName">
        <view class="status-content">
          <view class="status-text-area">
            <text class="status-main">{{ fobj.statecn }} {{ fobj.typecn || '' }}</text>
            <text class="status-sub">ID: {{ fobj.id }}</text>
          </view>
          <view class="status-icon">
            <text v-if="fobj.statecn === '已预约'">⏳</text>
            <text v-else-if="fobj.statecn === '已签到'">✅</text>
            <text v-else-if="fobj.statecn === '已完成'">🏆</text>
            <text v-else-if="fobj.statecn === '违规'">⚠️</text>
            <text v-else>📄</text>
          </view>
        </view>
      </view>

      <!-- 2. Ticket-style Info Card -->
      <view class="info-card ticket-card">
        <view class="card-section">
          <view class="room-title">{{ fobj.room }}</view>
          <view class="seat-badge">Seat: {{ fobj.site }}</view>
        </view>

        <view class="perforated-divider">
          <view class="cutout-left"></view>
          <view class="cutout-right"></view>
        </view>

        <view class="card-section">
          <view class="info-row">
            <view class="label">📅 预约日期</view>
            <view class="value">{{ fobj.ydate }}</view>
          </view>
          <view class="info-row">
            <view class="label">🕒 预约时段</view>
            <view class="value">{{ fobj.shiduan }}</view>
          </view>
          <view class="info-row">
            <view class="label">👤 联系电话</view>
            <view class="value">{{ fobj.tel }}</view>
          </view>
          <view class="info-row" v-if="fobj.stime">
            <view class="label">🕒 签到时间</view>
            <view class="value">{{ fobj.stime }}</view>
          </view>
          <view class="info-row" v-if="fobj.etime">
            <view class="label">🕒 结束时间</view>
            <view class="value">{{ fobj.etime }}</view>
          </view>
<!--          <view class="info-row">
            <view class="label">💰 支付金额</view>
            <view class="value price-text">¥{{ fobj.total }}</view>
          </view>-->
        </view>
      </view>

      <!-- 3. Actions -->
      <view class="action-section">
        <view class="btn-group" v-if="fobj.statecn === '已预约'">
          <u-button type="primary" @click="changeBillStatecn('已签到')" shape="circle">立即签到</u-button>
          <u-button class="cancel-btn" plain type="error" @click="changeBillStatecn('已取消')" shape="circle">取消预约</u-button>
        </view>

        <view class="btn-group" v-if="fobj.statecn === '已通过'">
          <u-button type="primary" @click="changeBillStatecn('已签到')" shape="circle">立即签到</u-button>
        </view>

        <view class="btn-group-row" v-if="fobj.statecn === '已签到'">
          <u-button class="flex-item" type="warning" @click="changeBillStatecn('暂时离开')" shape="circle">暂时离开</u-button>
          <u-button class="flex-item" type="primary" @click="changeBillStatecn('已完成')" shape="circle">结束使用</u-button>
        </view>

        <view class="btn-group" v-if="fobj.statecn === '暂时离开'">
          <u-button type="primary" @click="changeBillStatecn('已完成')" shape="circle">结束并结算</u-button>
        </view>
      </view>

      <!-- 4. Evaluation -->
      <view class="info-card" v-if="fobj.statecn === '已完成'">
        <view class="section-title">满意度评价</view>
        <view class="rate-container">
          <tn-rate v-model="pingfen" :size="50" activeColor="#4facfe"></tn-rate>
        </view>
        <view class="textarea-container">
          <tn-input v-model="rnote" type="textarea" placeholder="请输入您的评价内容..." :border="false" :height="160" />
        </view>
        <u-button type="primary" @click="pingjia()" customStyle="margin-top:20rpx;" shape="circle">提交评价</u-button>
      </view>

      <!-- 5. Evaluation Result -->
      <view class="info-card" v-if="fobj.pnote">
        <view class="section-title">我的评价</view>
        <view class="comment-display">
          <text class="comment-text">{{ fobj.pnote }}</text>
        </view>
      </view>

      <!-- 6. Goods List -->
      <view class="info-card" v-if="fobjgoodlist.length > 0">
        <view class="section-title">关联配套服务</view>
        <view v-for="(item,index) in fobjgoodlist" :key="index" class="service-item" @click="toGoodDetail(item.id, 1)">
          <image class="service-img" :src="fileUrl+item.img" mode="aspectFill"></image>
          <view class="service-meta">
            <text class="service-name">{{ item.gname }}</text>
            <text class="service-tag">配套设施</text>
          </view>
        </view>
      </view>

      <!-- Payment Popup -->
      <u-popup :closeable="true" @close="popshow=false" :show="popshow" mode="bottom" round="24rpx">
        <view class="pay-sheet">
          <view class="pay-title">确认支付</view>
          <view class="pay-price-box">
            <text class="currency">¥</text>
            <text class="amount">{{ fobj.total }}</text>
          </view>
          <view class="pay-form">
            <u--form>
              <u-form-item label="支付密码" labelWidth="80">
                <u--input border="bottom" type="password" v-model="passwd" placeholder="请输入6位支付密码" />
              </u-form-item>
            </u--form>
          </view>
          <view class="pay-confirm-btn">
            <u-button type="primary" @click="payBill()" shape="circle">确认并支付</u-button>
          </view>
        </view>
      </u-popup>

      <view class="safe-bottom-holder"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, listSqlj, deletej, fileUrl } from '@/common/config/api.js';
import { ideautil, yewuutil } from '@/common/commontools.js';
import { mapState, mapActions } from 'vuex'

export default {
  data() {
    return {
      paytotal:0,
      yhq:null,
      yhqlist:[],
      popshow:false,
      fobj: { paihao:1 },
      fobjgoodlist: [],
      fileUrl: fileUrl,
      passwd:'',
      pingfen:0,
      rnote:'',
      bid:null
    };
  },
  onLoad(params) {
    this.bid = params.bid
  },
  onShow(){
    findj({ params: { table: 'yuyue', id: this.bid } }).then(res => {
      res.paihao = 1
      this.fobj = res
      this.paytotal = this.fobj.total
      if(this.fobj.gids) {
        let sql = `select * from wct_good where id in (${this.fobj.gids})`;
        listSqlj({ params: { sql: sql } }).then(glist => {
          this.fobjgoodlist = glist
        })
      }
      this.checkQiandao(false)
    })
  },
  computed: {
    ...mapState(['userInfo']),
    // Logic to map Chinese states to English CSS classes to avoid Chinese in <style>
    statusClassName() {
      const state = this.fobj.statecn;
      if (state === '违规') return 'state-danger';
      if (state === '已完成' || state === '已评价') return 'state-finished';
      if (state === '已取消') return 'state-grey';
      return 'state-normal'; // Default blue for '已预约', '已签到' etc
    }
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    url2base64(img, cb) {
      let url = this.fileUrl + img;
      uni.request({
        url: url, method: 'GET', responseType: 'arraybuffer',
        success: (res) => {
          const base64 = uni.arrayBufferToBase64(res.data);
          cb && cb(base64);
        }
      });
    },
    changeBillStatecn(statecn){
      this.fobj.statecn = statecn;
      let params = {table: 'yuyue', id: this.fobj.id, statecn: statecn};
      let nowStr = uni.itool.getNtime();
      
      if(statecn == '已签到'){
        params.stime = nowStr;
        this.fobj.stime = nowStr;
      } else if(statecn == '已完成'){
        params.etime = nowStr;
        this.fobj.etime = nowStr;
        // 计算时长并增加积分
        this.calculateJifen(this.fobj.stime, nowStr);
      }
      
      savej({params: params}).then(() => {
        if(statecn == '已签到') this.checkQiandao(true);
        uni.showToast({ title: '操作成功' });
      });
    },
    calculateJifen(stime, etime) {
      if(!stime || !etime) return;
      try {
        let sdate = new Date(stime.replace(/-/g, '/'));
        let edate = new Date(etime.replace(/-/g, '/'));
        let diffMs = edate.getTime() - sdate.getTime();
        if(diffMs < 0) diffMs = 0;
        
        let minutes = Math.floor(diffMs / (1000 * 60));
        if(minutes > 0) {
          let currentJifen = (this.userInfo.money || 0) * 1;
          let newJifen = currentJifen + minutes;
          
          savej({params: {table: 'user', id: this.userInfo.id, money: newJifen}}).then(() => {
            this.userInfo.money = newJifen;
            this.updateUserInfo(this.userInfo);
            uni.showModal({
              title: '使用完成',
              content: `您本次使用时长为 ${minutes} 分钟，已为您增加 ${minutes} 积分！`,
              showCancel: false
            });
          });
        }
      } catch (e) {
        console.error('计算积分失败', e);
      }
    },
    checkQiandao(flag){
      let typecn = null;
      if(!this.fobj.shiduan) return;
      let shiduans = this.fobj.shiduan.split("-");
      let stimestr = shiduans[0]+":00";
      let etimestr = shiduans[1]+":00";
      let str = this.fobj.ydate+" "+stimestr;
      let etr = this.fobj.ydate+" "+etimestr;
      let sdate = new Date(Date.parse(str.replace(/-/g, "/")));
      let edate = new Date(Date.parse(etr.replace(/-/g, "/")));
      let nt = Date.now();
      let st = sdate.getTime();
      let et = edate.getTime();
      if(nt > et) typecn = '迟到';
      if(nt > st && nt<et) typecn = '正常';
      if(nt > et+(30*60*1000)) typecn = '违规';
      if(flag && typecn){
        savej({params: {table:'yuyue',typecn:typecn,id:this.fobj.id}});
      } else if(!flag && this.fobj.statecn == '已预约' && typecn == '违规'){
        savej({params: {table:'yuyue',typecn:typecn,id:this.fobj.id,statecn: '违规'}}).then(() => {
          this.fobj.statecn = '违规';
          this.fobj.typecn = typecn;
        });
      }
    },
    pingjia(){
      this.fobj.statecn = "已评价";
      this.fobj.pnote = this.rnote;
      this.fobj.pf = this.pingfen;
      savej({params: {table: 'yuyue',id: this.fobj.id, pf: this.fobj.pf, pnote: this.fobj.pnote, statecn: this.fobj.statecn}}).then(() => {
        uni.showToast({ title: '评价成功' });
      });
    },
    payBill(){
      if(this.passwd == this.userInfo.passwd){
        let mymoney = (this.userInfo.money||0)*1;
        if (mymoney < this.paytotal) {
          uni.showToast({ icon:'none', title: '余额不足!', success:()=>{ setTimeout(()=>{ uni.redirectTo({ url:'/pages/qianbao/charge' }) },1500) } });
        } else {
          mymoney -= this.paytotal;
          savej({params: {table: 'user', id: this.userInfo.id, money: mymoney }}).then(() => {
            this.userInfo.money = mymoney;
            this.updateUserInfo(this.userInfo);
            this.yuyueCommit();
          });
        }
      } else { uni.showToast({ title: '密码错误', icon: 'error' }); }
    },
    yuyueCommit(){
      let statecn = '已预约';
      savej({params: {table: 'yuyue', statecn: statecn, id: this.fobj.id}}).then(() => {
        this.fobj.statecn = statecn; this.popshow = false;
        uni.showToast({ title: '支付成功' });
      });
    },
    goBack() { uni.switchTab({ url:'/pages/yuyue/yuyue' }); },
    toGoodDetail: yewuutil.toGoodDetail,
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

/* Header States */
.status-header {
  padding: 60rpx 40rpx;
  color: #ffffff;
  transition: all 0.3s;
}

.state-normal {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.state-danger {
  background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
}

.state-finished {
  background: linear-gradient(135deg, #6a85b6 0%, #bac8e0 100%);
}

.state-grey {
  background: linear-gradient(135deg, #94a3b8 0%, #cbd5e1 100%);
}

.status-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-main {
  font-size: 44rpx;
  font-weight: 800;
  display: block;
  margin-bottom: 8rpx;
}

.status-sub {
  font-size: 24rpx;
  opacity: 0.85;
}

.status-icon {
  font-size: 80rpx;
}

/* Main Cards */
.info-card {
  margin: -30rpx 24rpx 24rpx;
  background-color: #ffffff;
  border-radius: 24rpx;
  padding: 40rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.04);
  position: relative;
}

.ticket-card {
  padding: 0;
  overflow: hidden;
}

.card-section {
  padding: 40rpx;
}

.room-title {
  font-size: 38rpx;
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 20rpx;
}

.seat-badge {
  display: inline-block;
  background-color: #f0f7ff;
  color: #3b82f6;
  padding: 12rpx 32rpx;
  border-radius: 100rpx;
  font-size: 28rpx;
  font-weight: bold;
}

/* Perforated Divider Styling */
.perforated-divider {
  height: 2rpx;
  border-bottom: 2rpx dashed #e2e8f0;
  margin: 0 40rpx;
  position: relative;
}

.cutout-left, .cutout-right {
  width: 32rpx;
  height: 32rpx;
  background-color: #f6f8fb;
  border-radius: 50%;
  position: absolute;
  top: -16rpx;
}
.cutout-left { left: -56rpx; }
.cutout-right { right: -56rpx; }

/* Detail Rows */
.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28rpx;
  &:last-child { margin-bottom: 0; }
}

.label { color: #64748b; font-size: 28rpx; }
.value { color: #1e293b; font-size: 28rpx; font-weight: 600; }
.price-text { color: #ef4444; font-size: 34rpx; font-weight: 800; }

/* Action Buttons */
.action-section {
  padding: 10rpx 24rpx 30rpx;
}

.btn-group {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.btn-group-row {
  display: flex;
  gap: 20rpx;
}

.flex-item { flex: 1; }

/* Sections titles */
.section-title {
  font-size: 30rpx;
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 30rpx;
  border-left: 10rpx solid #3b82f6;
  padding-left: 20rpx;
}

.rate-container {
  display: flex;
  justify-content: center;
  margin-bottom: 30rpx;
}

.textarea-container {
  background-color: #f8fafc;
  border-radius: 16rpx;
  padding: 10rpx 20rpx;
}

/* Service Item Style */
.service-item {
  display: flex;
  align-items: center;
  padding: 24rpx;
  background-color: #f8fafc;
  border-radius: 20rpx;
  margin-bottom: 20rpx;
  border: 1rpx solid #f1f5f9;
}

.service-img {
  width: 100rpx;
  height: 100rpx;
  border-radius: 12rpx;
  margin-right: 24rpx;
}

.service-name { font-size: 28rpx; color: #1e293b; font-weight: 700; margin-bottom: 4rpx; }
.service-tag { font-size: 22rpx; color: #94a3b8; }

/* Evaluation Display */
.comment-display {
  background-color: #f0f9ff;
  padding: 24rpx;
  border-radius: 16rpx;
}
.comment-text { font-size: 28rpx; color: #0369a1; line-height: 1.5; }

/* Pay Sheet */
.pay-sheet {
  padding: 50rpx 40rpx;
  text-align: center;
}

.pay-title { font-size: 34rpx; font-weight: 800; margin-bottom: 40rpx; color: #1e293b; }
.pay-price-box { margin-bottom: 50rpx; }
.currency { font-size: 36rpx; font-weight: 800; color: #1e293b; margin-right: 4rpx; }
.amount { font-size: 72rpx; font-weight: 800; color: #1e293b; }

.pay-confirm-btn { margin-top: 60rpx; }

.safe-bottom-holder { height: 80rpx; }

/* Responsive Web Layout */
@media screen and (min-width: 768px) {
  .page-container {
    max-width: 480px;
    margin: 0 auto;
    border-left: 1rpx solid #e2e8f0;
    border-right: 1rpx solid #e2e8f0;
  }
}
</style>