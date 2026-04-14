<template>
	<view class="page-container">
		<u-navbar title="兑换记录" :border="false" :placeholder="true" @leftClick="goBack" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<view class="tabs-box">
			<u-tabs 
				:list="typelist" 
				keyName="title" 
				@change="onTabChange"
				lineWidth="40rpx"
				lineHeight="6rpx"
				:activeStyle="{ color: '#3b82f6', fontWeight: 'bold' }"
				:inactiveStyle="{ color: '#64748b' }"
			></u-tabs>
		</view>

		<scroll-view scroll-y class="content-scroll">
			<view class="bill-list">
				<view v-for="(item, index) in fobjlist" :key="index" class="bill-card" @click="fobjDetail(item.id)">
					<view class="bill-header">
						<text class="bill-date">{{ item.ndate }}</text>
						<text :class="['bill-status', 
							item.statecn === '待付款' ? 'status-pending' : 
							item.statecn === '已付款' ? 'status-paid' : 
							item.statecn === '已完成' ? 'status-done' : 'status-default'
						]">{{ item.statecn }}</text>
					</view>
					
					<view class="bill-body">
						<view class="good-info">
							<text class="good-names">{{ item.gnames }}</text>
							<text class="good-count">共 {{ getCount(item.gcounts) }} 件商品</text>
						</view>
						<view class="price-info">
							<text class="price-val">{{ item.total }}</text>
							<text class="price-unit">积分</text>
						</view>
					</view>
					
					<view class="bill-footer">
						<text class="bill-id">订单号: {{ item.id }}</text>
						<view class="action-hint">
							<text>查看详情</text>
							<u-icon name="arrow-right" size="14" color="#94a3b8"></u-icon>
						</view>
					</view>
				</view>
			</view>
			
			<u-empty v-if="fobjlist.length === 0" mode="order" text="暂无相关兑换记录" marginTop="200"></u-empty>
			<view class="safe-bottom"></view>
		</scroll-view>
	</view>
</template>

<script>
	import { listj } from '@/common/config/api.js'
	import { mapState } from 'vuex'
	
	export default {
		data() {
			return {
				fobjlist: [],
				tabtitle: null,
				typelist: [
					{ title: '全部' }, 
					{ title: '待付款' }, 
					{ title: '已付款' }, 
					{ title: '已完成' }
				]
			};
		},
		onShow() {
			this.refreshBill()
		},
		methods: {
			onTabChange(item) {
				this.tabtitle = item.title === '全部' ? null : item.title;
				this.refreshBill()
			},
			refreshBill() {
				listj({ params: { table: 'bill', statecn: this.tabtitle, uid: this.userInfo.id } }).then(res => {
					this.fobjlist = res || [];
				});
			},
			fobjDetail(bid) {
				uni.navigateTo({
					url: '/pages/bill/billdetail?bid=' + bid
				});
			},
			goBack() {
				uni.switchTab({
					url: '/pages/me/me'
				});
			},
			getCount(gcounts) {
				if (!gcounts) return 0;
				if (typeof gcounts === 'string') {
					return gcounts.split(',').reduce((a, b) => parseInt(a) + parseInt(b), 0);
				}
				return gcounts;
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

.tabs-box {
	background-color: #ffffff;
	padding-bottom: 10rpx;
}

.content-scroll {
	height: calc(100vh - 44px - 100rpx);
}

.bill-list {
	padding: 24rpx;
}

.bill-card {
	background-color: #ffffff;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-bottom: 24rpx;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.02);
	
	&:active {
		background-color: #f8fafc;
	}
}

.bill-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24rpx;
	padding-bottom: 20rpx;
	border-bottom: 1rpx solid #f1f5f9;
}

.bill-date {
	font-size: 24rpx;
	color: #94a3b8;
}

.bill-status {
	font-size: 22rpx;
	font-weight: bold;
	padding: 4rpx 16rpx;
	border-radius: 8rpx;
}

.status-pending { color: #f59e0b; background-color: #fffbeb; }
.status-paid { color: #3b82f6; background-color: #eff6ff; }
.status-done { color: #10b981; background-color: #ecfdf5; }
.status-default { color: #64748b; background-color: #f1f5f9; }

.bill-body {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 24rpx;
}

.good-info {
	flex: 1;
	margin-right: 20rpx;
}

.good-names {
	font-size: 28rpx;
	font-weight: bold;
	color: #1e293b;
	margin-bottom: 8rpx;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	-webkit-line-clamp: 2;
	overflow: hidden;
}

.good-count {
	font-size: 22rpx;
	color: #94a3b8;
}

.price-info {
	text-align: right;
}

.price-val {
	font-size: 32rpx;
	font-weight: 800;
	color: #1e293b;
}

.price-unit {
	font-size: 20rpx;
	color: #64748b;
	margin-left: 4rpx;
}

.bill-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.bill-id {
	font-size: 22rpx;
	color: #cbd5e1;
}

.action-hint {
	display: flex;
	align-items: center;
	gap: 4rpx;
	font-size: 24rpx;
	color: #94a3b8;
}

.safe-bottom {
	height: 60rpx;
}
</style>
