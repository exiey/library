<template>
	<view class="page-container">
		<u-navbar title="订单详情" :border="false" :placeholder="true" @leftClick="goBack" :autoBack="false" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<scroll-view scroll-y class="content-scroll">
			<!-- 1. 状态头部 -->
			<view class="status-banner" :class="statusClassName">
				<view class="status-info">
					<text class="status-text">{{ fobj.statecn }}</text>
					<text class="order-id">订单号：{{ fobj.id }}</text>
				</view>
				<view class="status-icon">
					<text v-if="fobj.statecn === '待付款'">⏳</text>
					<text v-else-if="fobj.statecn === '已付款'">✅</text>
					<text v-else-if="fobj.statecn === '已完成'">🏆</text>
					<text v-else>📄</text>
				</view>
			</view>

			<!-- 2. 配送/联系信息 -->
			<view class="info-card">
				<view class="section-title">收货信息</view>
				<view class="info-row">
					<u-icon name="map-fill" size="18" color="#3b82f6"></u-icon>
					<text class="info-val">{{ fobj.address || '自提' }}</text>
				</view>
				<view class="info-row">
					<u-icon name="calendar-fill" size="18" color="#3b82f6"></u-icon>
					<text class="info-val">{{ fobj.ndate }}</text>
				</view>
			</view>

			<!-- 3. 商品清单 -->
			<view class="info-card">
				<view class="section-title">商品清单</view>
				<view v-for="(item, index) in fobjgoodlist" :key="index" class="good-item" @click="toGoodDetail(item.id, 1)">
					<image class="good-img" :src="fileUrl+item.img" mode="aspectFill"></image>
					<view class="good-meta">
						<text class="good-name">{{ item.gname }}</text>
						<view class="good-price-row">
							<text class="good-price">{{ item.price }} 积分</text>
							<!-- 这里假设后台没存单项数量，如果有可以显示 x{{ item.count }} -->
						</view>
					</view>
				</view>
				<view class="total-row">
					<text>合计积分</text>
					<text class="total-val">{{ fobj.total }}</text>
				</view>
			</view>

			<!-- 4. 评价显示 -->
			<view class="info-card" v-if="fobj.pnote">
				<view class="section-title">我的评价</view>
				<view class="comment-box">
					<view class="rate-display">
						<u-rate :value="fobj.pf" readonly activeColor="#f59e0b" size="16"></u-rate>
					</view>
					<text class="comment-text">{{ fobj.pnote }}</text>
				</view>
			</view>

			<!-- 5. 评价输入 (待评价状态) -->
			<view class="info-card" v-if="fobj.statecn === '待评价' || (fobj.statecn === '已完成' && !fobj.pnote)">
				<view class="section-title">发布评价</view>
				<view class="write-comment">
					<view class="rate-input">
						<text>评分：</text>
						<u-rate v-model="pingfen" activeColor="#3b82f6" size="24"></u-rate>
					</view>
					<u--textarea v-model="rnote" placeholder="写下您的兑换心得..." border="none" bgColor="#f8fafc"></u--textarea>
					<u-button type="primary" shape="circle" text="提交评价" @click="pingjia()" customStyle="margin-top: 30rpx;"></u-button>
				</view>
			</view>

			<view class="safe-bottom"></view>
		</scroll-view>

		<!-- 6. 底部操作栏 (待付款状态) -->
		<view class="bottom-bar" v-if="fobj.statecn === '待付款'">
			<view class="action-btns">
				<u-button plain type="info" shape="circle" text="取消订单" @click="changeBillStatecn('已取消')" customStyle="flex: 1;"></u-button>
				<u-button type="primary" shape="circle" text="立即付款" @click="popshow=true" customStyle="flex: 2;"></u-button>
			</view>
		</view>

		<!-- 支付弹窗 -->
		<u-popup :closeable="true" @close="popshow=false" :show="popshow" mode="bottom" round="32rpx">
			<view class="pay-panel">
				<view class="pay-header">确认支付</view>
				<view class="pay-amount">
					<text class="num">{{ fobj.total }}</text>
					<text class="unit">积分</text>
				</view>
				
				<view class="pay-form">
					<u-form-item label="支付密码" labelWidth="160">
						<u--input type="password" v-model="passwd" placeholder="请输入支付密码" border="bottom"></u--input>
					</u-form-item>
				</view>
				
				<u-button type="primary" shape="circle" text="确认扣除积分" @click="payBill()" customStyle="margin-top: 60rpx; height: 90rpx; font-weight: bold;"></u-button>
			</view>
		</u-popup>
	</view>
</template>

<script>
	import { listj, findj, savej, listSqlj, fileUrl } from '@/common/config/api.js';
	import { ideautil, yewuutil } from '@/common/commontools.js';
	import { mapState, mapActions } from 'vuex'

	export default {
		data() {
			return {
				paytotal: 0,
				yhq: null,
				yhqlist: [],
				popshow: false,
				fobj: {},
				fobjgoodlist: [],
				fileUrl: fileUrl,
				passwd: '',
				pingfen: 5,
				rnote: '',
				bid: null
			}
		},
		onLoad(params) {
			this.bid = params.bid
			this.fetchDetail()
		},
		methods: {
			...mapActions(['updateUserInfo']),
			fetchDetail() {
				findj({ params: { table: 'bill', id: this.bid } }).then(res => {
					this.fobj = res
					this.paytotal = this.fobj.total
					let gids = this.fobj.gids;
					let sql = `select * from wct_good where id in (${gids})`;
					listSqlj({ params: { sql: sql } }).then(glist => {
						this.fobjgoodlist = glist
					});
				});
			},
			changeBillStatecn(statecn) {
				savej({ params: { table: 'bill', id: this.fobj.id, statecn: statecn } }).then(() => {
					this.fobj.statecn = statecn
					uni.showToast({ title: '操作成功' })
				});
			},
			pingjia() {
				if (!this.rnote) {
					uni.showToast({ icon: 'none', title: '请输入评价内容' });
					return;
				}
				let statecn = "已评价"
				savej({ params: { table: 'bill', id: this.fobj.id, pf: this.pingfen, pnote: this.rnote, statecn: statecn } }).then(() => {
					this.fobj.statecn = statecn
					this.fobj.pnote = this.rnote
					this.fobj.pf = this.pingfen
					uni.showToast({ title: '感谢评价' })
				});
			},
			payBill() {
				if (this.passwd === this.userInfo.passwd) {
					let myjifen = (this.userInfo.jifen || 0) * 1
					if (myjifen < this.paytotal) {
						uni.showToast({ icon: 'none', title: '积分不足' });
					} else {
						myjifen -= this.paytotal
						savej({ params: { table: 'user', id: this.userInfo.id, jifen: myjifen } }).then(() => {
							this.userInfo.jifen = myjifen
							this.updateUserInfo(this.userInfo)
							this.billCommit()
						})
					}
				} else {
					uni.showToast({ title: '密码错误', icon: 'error' });
				}
			},
			billCommit() {
				let statecn = '已付款'
				savej({ params: { table: 'bill', statecn: statecn, id: this.fobj.id } }).then(() => {
					this.fobj.statecn = statecn
					this.popshow = false
					uni.showToast({ title: '支付成功' })
				});
			},
			goBack() {
				uni.redirectTo({ url: '/pages/bill/bill' });
			},
			toGoodDetail: yewuutil.toGoodDetail
		},
		computed: {
			...mapState(['userInfo']),
			statusClassName() {
				const state = this.fobj.statecn;
				if (state === '待付款') return 'bg-pending';
				if (state === '已付款') return 'bg-paid';
				if (state === '已完成' || state === '已评价') return 'bg-done';
				return 'bg-default';
			}
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

.status-banner {
	padding: 60rpx 40rpx;
	display: flex;
	justify-content: space-between;
	align-items: center;
	color: #ffffff;
}

.bg-pending { background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%); }
.bg-paid { background: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%); }
.bg-done { background: linear-gradient(135deg, #10b981 0%, #34d399 100%); }
.bg-default { background: linear-gradient(135deg, #94a3b8 0%, #cbd5e1 100%); }

.status-text { font-size: 44rpx; font-weight: 800; display: block; margin-bottom: 8rpx; }
.order-id { font-size: 24rpx; opacity: 0.8; }
.status-icon { font-size: 80rpx; }

.info-card {
	margin: 24rpx;
	background-color: #ffffff;
	border-radius: 24rpx;
	padding: 30rpx;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.02);
}

.section-title {
	font-size: 28rpx;
	font-weight: bold;
	color: #1e293b;
	margin-bottom: 24rpx;
	padding-left: 16rpx;
	border-left: 6rpx solid #3b82f6;
}

.info-row {
	display: flex;
	align-items: center;
	gap: 16rpx;
	margin-bottom: 16rpx;
	&:last-child { margin-bottom: 0; }
}

.info-val { font-size: 26rpx; color: #475569; }

.good-item {
	display: flex;
	gap: 20rpx;
	padding: 20rpx 0;
	border-bottom: 1rpx solid #f1f5f9;
	&:last-child { border-bottom: none; }
}

.good-img {
	width: 120rpx;
	height: 120rpx;
	border-radius: 12rpx;
	background-color: #f1f5f9;
}

.good-meta {
	flex: 1;
	display: flex;
	flex-direction: column;
	justify-content: center;
}

.good-name { font-size: 28rpx; font-weight: bold; color: #1e293b; margin-bottom: 8rpx; }
.good-price { font-size: 24rpx; color: #3b82f6; font-weight: bold; }

.total-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 30rpx;
	padding-top: 20rpx;
	border-top: 2rpx dashed #e2e8f0;
	font-size: 28rpx;
	font-weight: bold;
	color: #1e293b;
}

.total-val { font-size: 36rpx; color: #ef4444; }

.comment-box {
	background-color: #f8fafc;
	padding: 20rpx;
	border-radius: 16rpx;
}

.rate-display { margin-bottom: 12rpx; }
.comment-text { font-size: 26rpx; color: #475569; line-height: 1.5; }

.write-comment {
	background-color: #f8fafc;
	border-radius: 16rpx;
	padding: 20rpx;
}

.rate-input { display: flex; align-items: center; margin-bottom: 24rpx; font-size: 26rpx; color: #64748b; }

.bottom-bar {
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	background-color: #ffffff;
	padding: 20rpx 30rpx;
	padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
	box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.action-btns { display: flex; gap: 20rpx; }

.pay-panel {
	padding: 50rpx 40rpx;
	text-align: center;
}

.pay-header { font-size: 32rpx; font-weight: bold; color: #1e293b; margin-bottom: 40rpx; }
.pay-amount { margin-bottom: 50rpx; color: #ef4444; }
.pay-amount .num { font-size: 64rpx; font-weight: 800; }
.pay-amount .unit { font-size: 24rpx; margin-left: 8rpx; }

.pay-form { text-align: left; }

.safe-bottom { height: 140rpx; }
</style>
