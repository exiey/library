<template>
	<view class="page-container">
		<u-navbar title="虚拟饰品兑换" :border="false" :placeholder="true" :autoBack="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<scroll-view scroll-y class="content-scroll">
			<view class="grid-container">
				<view v-for="(item, index) in fobjList" :key="index" class="good-card" @click="toDetail(item.id)">
					<image class="good-img" :src="fileUrl + item.img" mode="aspectFill"></image>
					<view class="good-info">
						<text class="good-name">{{ item.gname }}</text>
						<view class="price-row">
							<text class="price-val">{{ item.price }}</text>
							<text class="price-unit">积分</text>
						</view>
						<view class="good-tag">{{ item.type }}</view>
					</view>
				</view>
			</view>
			
			<u-empty v-if="fobjList.length === 0" mode="list" text="暂无可用饰品" marginTop="200"></u-empty>
			<view class="safe-bottom"></view>
		</scroll-view>
	</view>
</template>

<script>
	import { listj, fileUrl } from '@/common/config/api.js';
	import { mapState } from 'vuex';
	
	export default {
		data() {
			return {
				fobjList: [],
				fileUrl: fileUrl
			};
		},
		onLoad() {
			this.fetchGoods();
		},
		methods: {
			fetchGoods() {
				listj({params: {table: 'good'}}).then(res => {
					this.fobjList = res || [];
				});
			},
			toDetail(id) {
				uni.navigateTo({
					url: './gooddetail?gid=' + id
				});
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

.grid-container {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 24rpx;
	padding: 24rpx;
}

.good-card {
	background-color: #ffffff;
	border-radius: 24rpx;
	overflow: hidden;
	box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.03);
	transition: transform 0.2s;
	
	&:active {
		transform: scale(0.98);
	}
}

.good-img {
	width: 100%;
	height: 320rpx;
	background-color: #f1f5f9;
}

.good-info {
	padding: 20rpx;
}

.good-name {
	font-size: 28rpx;
	font-weight: bold;
	color: #1e293b;
	margin-bottom: 12rpx;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	-webkit-line-clamp: 1;
	overflow: hidden;
}

.price-row {
	display: flex;
	align-items: baseline;
	margin-bottom: 12rpx;
}

.price-val {
	font-size: 36rpx;
	font-weight: 800;
	color: #3b82f6;
	margin-right: 4rpx;
}

.price-unit {
	font-size: 22rpx;
	color: #64748b;
}

.good-tag {
	display: inline-block;
	font-size: 20rpx;
	color: #94a3b8;
	background-color: #f1f5f9;
	padding: 4rpx 12rpx;
	border-radius: 6rpx;
}

.safe-bottom {
	height: 60rpx;
}
</style>