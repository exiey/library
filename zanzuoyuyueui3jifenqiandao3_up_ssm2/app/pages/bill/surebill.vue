<template>
	<view class="page-container">
		<u-navbar title="确认兑换" :border="false" :placeholder="true" :autoBack="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<scroll-view scroll-y class="content-scroll">
			<!-- 1. 配送/联系地址选择 -->
			<view class="section-card">
				<view class="section-title">联系信息</view>
				<view class="address-list">
					<u-radio-group v-model="address" placement="column">
						<view v-for="(item, index) in addressList" :key="index" class="address-item" @click="address = item.title">
							<u-radio :name="item.title" :label="item.title" activeColor="#3b82f6"></u-radio>
						</view>
					</u-radio-group>
				</view>
				<u-empty v-if="addressList.length === 0" mode="address" text="请先添加地址" size="120" @click="toAddress"></u-empty>
			</view>

			<!-- 2. 商品清单 -->
			<view class="section-card">
				<view class="section-header">
					<text class="section-title">兑换清单</text>
					<text class="item-count">共 {{ bills.length }} 笔订单</text>
				</view>
				
				<view class="good-summary">
					<view class="info-row">
						<text class="label">商品信息</text>
						<text class="val">{{ gnames }}</text>
					</view>
					<view class="info-row">
						<text class="label">消耗总计</text>
						<view class="val-group">
							<text class="total-num">{{ paytotal }}</text>
							<text class="total-unit">积分</text>
						</view>
					</view>
				</view>
			</view>

			<!-- 3. 订单备注 -->
			<view class="section-card">
				<view class="section-title">备注信息</view>
				<view class="textarea-box">
					<u--textarea v-model="bnote" placeholder="选填：对本次兑换的特殊要求..." border="none" bgColor="#f8fafc" height="120"></u--textarea>
				</view>
			</view>

			<view class="safe-bottom"></view>
		</scroll-view>

		<!-- 4. 底部提交栏 -->
		<view class="bottom-bar">
			<view class="price-display">
				<text class="label">合计：</text>
				<text class="total-val">{{ paytotal }}</text>
				<text class="unit">积分</text>
			</view>
			<u-button type="primary" shape="circle" text="立即支付" @click="popshow=true" :customStyle="{ width: '240rpx', height: '80rpx', fontWeight: 'bold' }"></u-button>
		</view>

		<!-- 5. 支付弹窗 -->
		<u-popup :closeable="true" @close="popshow=false" :show="popshow" mode="bottom" round="32rpx">
			<view class="pay-panel">
				<view class="pay-header">确认支付</view>
				<view class="pay-amount">
					<text class="num">{{ paytotal }}</text>
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
	import { mapState, mapActions } from 'vuex'
	import { listj, findj, savej } from '@/common/config/api.js';
	import { ideautil } from '@/common/commontools.js';

	export default {
		data() {
			return {
				addressList: [],
				bills: [],
				address: '',
				bnote: '',
				gnames: '',
				gids: '',
				paytotal: 0,
				total: 0,
				statecn: '待付款',
				popshow: false,
				passwd: '',
				paygoodslist: []
			};
		},
		onLoad() {
			this.initOrderData();
			this.fetchAddresses();
		},
		methods: {
			...mapActions(['updateUserInfo', 'setCar']),
			
			fetchAddresses() {
				listj({ params: { table: 'address', uid: this.userInfo.id } }).then(res => {
					this.addressList = res || [];
					if (this.addressList.length > 0) {
						this.address = this.addressList[0].title;
					}
				});
			},

			initOrderData() {
				let list = this.carlist.filter(item => item.checked);
				let shopslist = [];
				list.forEach(obj => {
					if (!ideautil.checkStrInList(obj.sid, shopslist)) {
						shopslist.push(obj.sid);
					}
				});

				shopslist.forEach(sid => {
					let btotal = 0;
					let bgnames = '';
					let bgids = '';
					let bgcounts = '';
					let sname = '';
					
					list.filter(obj => obj.sid === sid).forEach(obj => {
						let price = obj.price * 1;
						let count = obj.count * 1;
						btotal += price * count;
						
						if (bgnames === '') {
							bgnames = obj.gname + "*" + count;
							bgids = obj.id;
							bgcounts = count;
						} else {
							bgnames += "," + obj.gname + "*" + count;
							bgids += "," + obj.id;
							bgcounts += "," + count;
						}
						
						if (sname === '') sname = obj.shop;
						
						let mcount = (obj.mcount || 0) * 1;
						mcount = Math.max(0, mcount - count);
						this.paygoodslist.push({ table: 'good', mcount: mcount, id: obj.id });
					});

					let shopbill = {
						total: btotal,
						gnames: bgnames,
						gids: bgids,
						shop: sname,
						sid: sid,
						gcounts: bgcounts
					};
					
					this.bills.push(shopbill);
					this.gnames = this.gnames ? (this.gnames + ',' + bgnames) : bgnames;
					this.total += btotal;
				});
				this.paytotal = this.total;
			},

			async billCommit() {
				if (!this.address) {
					uni.showToast({ icon: 'none', title: '请先选择地址' });
					return;
				}

				for (let obj of this.bills) {
					let params = {
						...obj,
						address: this.address,
						username: this.userInfo.username,
						uid: this.userInfo.id,
						note: this.bnote,
						user: this.userInfo.username,
						statecn: this.statecn,
						table: 'bill'
					};
					await savej({ params: params });
				}

				// 清理购物车
				let carlist = this.carlist;
				let paylist = this.paygoodslist;
				let newcarlist = carlist.filter(c => !paylist.some(p => p.id === c.id));
				this.setCar(newcarlist);

				uni.showToast({
					title: '提交成功',
					success: () => {
						setTimeout(() => {
							uni.redirectTo({ url: '/pages/bill/bill' });
						}, 1500);
					}
				});
			},

			payBill() {
				if (this.passwd === this.userInfo.passwd) {
					let myjifen = (this.userInfo.money || 0) * 1;
					if (myjifen < this.paytotal) {
						uni.showToast({
							icon: 'none',
							title: '积分不足，尝试先提交订单...',
							success: () => {
								setTimeout(() => this.billCommit(), 1500);
							}
						});
					} else {
						myjifen -= this.paytotal;
						savej({ params: { table: 'user', id: this.userInfo.id, money: myjifen } }).then(() => {
							this.userInfo.money = myjifen;
							this.updateUserInfo(this.userInfo);
							this.statecn = '已付款';
							this.billCommit();
						});
					}
				} else {
					uni.showToast({ title: '密码错误', icon: 'error' });
				}
			},

			toAddress() {
				uni.navigateTo({ url: '/pages/address/address' });
			},
			
			goBack() {
				uni.navigateBack();
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
	background-color: #f8fafc;
}

.content-scroll {
	height: calc(100vh - 44px - 120rpx);
}

.section-card {
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

.address-item {
	padding: 20rpx 0;
	border-bottom: 1rpx solid #f1f5f9;
	&:last-child { border-bottom: none; }
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30rpx;
}

.item-count { font-size: 22rpx; color: #94a3b8; }

.good-summary {
	background-color: #f8fafc;
	padding: 24rpx;
	border-radius: 16rpx;
}

.info-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 16rpx;
	&:last-child { margin-bottom: 0; }
}

.label { font-size: 26rpx; color: #64748b; }
.val { font-size: 26rpx; color: #1e293b; flex: 1; text-align: right; margin-left: 40rpx; }

.val-group {
	display: flex;
	align-items: baseline;
	color: #3b82f6;
	.total-num { font-size: 36rpx; font-weight: 800; }
	.total-unit { font-size: 22rpx; margin-left: 4rpx; }
}

.textarea-box {
	background-color: #f8fafc;
	border-radius: 16rpx;
	padding: 10rpx;
}

.bottom-bar {
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 120rpx;
	background-color: #ffffff;
	padding: 0 40rpx;
	padding-bottom: env(safe-area-inset-bottom);
	box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
	display: flex;
	justify-content: space-between;
	align-items: center;
	z-index: 10;
}

.price-display {
	display: flex;
	align-items: baseline;
	.label { font-size: 24rpx; color: #64748b; }
	.total-val { font-size: 44rpx; font-weight: 800; color: #ef4444; }
	.unit { font-size: 22rpx; color: #ef4444; margin-left: 4rpx; }
}

.pay-panel {
	padding: 50rpx 40rpx;
	text-align: center;
}

.pay-header { font-size: 32rpx; font-weight: bold; color: #1e293b; margin-bottom: 40rpx; }
.pay-amount { margin-bottom: 50rpx; color: #ef4444; }
.pay-amount .num { font-size: 64rpx; font-weight: 800; }
.pay-amount .unit { font-size: 24rpx; margin-left: 8rpx; }

.pay-form { text-align: left; }

.safe-bottom { height: 60rpx; }
</style>