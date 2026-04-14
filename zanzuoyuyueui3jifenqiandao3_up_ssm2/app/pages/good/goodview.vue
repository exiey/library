<template>
	<view class="page-container">
		<u-navbar @leftClick="goBack" title="饰品商城" :border="false" :placeholder="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<view class="search-sticky">
			<u-search placeholder="搜索感兴趣的饰品..." v-model="searchstr" :showAction="false" shape="round" bgColor="#f1f5f9"></u-search>
		</view>

		<view class="main-content">
			<!-- 左侧分类 -->
			<scroll-view scroll-y class="side-bar">
				<view 
					v-for="(item, index) in typelist" 
					:key="item.id" 
					:class="['side-item', activeTypeId === item.id ? 'active' : '']"
					@click="refreshGood(item.id)"
				>
					<text>{{ item.title }}</text>
				</view>
			</scroll-view>

			<!-- 右侧列表 -->
			<scroll-view scroll-y class="good-list-scroll">
				<view class="good-grid">
					<view v-for="(item, index) in fobjList" :key="index" class="good-item" @click="toGoodDetail(item.id)">
						<image class="good-img" :src="fileUrl+item.img" mode="aspectFill"></image>
						<view class="good-info">
							<text class="good-name">{{ item.gname }}</text>
							<view class="price-row">
								<text class="price-val">{{ item.price }}</text>
								<text class="price-unit">积分</text>
							</view>
						</view>
					</view>
				</view>
				<u-empty v-if="fobjList.length === 0" mode="search" text="没有找到相关饰品" marginTop="100"></u-empty>
				<view class="safe-bottom"></view>
			</scroll-view>
		</view>
	</view>
</template>

<script>
	import { listj, fileUrl } from '@/common/config/api.js'
	import { yewuutil } from '@/common/commontools.js'
	import { mapState } from 'vuex'
	
	export default {
		data() {
			return {
				searchstr: '',
				fileUrl: fileUrl,
				fobjList: [],
				typelist: [],
				activeTypeId: 0
			}
		},
		onLoad() {
			this.fetchTypes();
			this.refreshGood(0);
		},
		methods: {
			fetchTypes() {
				listj({params: {table: 'type2'}}).then(res => {
					this.typelist = [{id: 0, title: "全部"}, ...(res || [])];
				});
			},
			refreshGood(id) {
				this.activeTypeId = id;
				let params = { table: 'good' };
				if (id !== 0) params.typeid = id;
				if (this.searchstr) params.gname = this.searchstr;
				
				listj({params: params}).then(res => {
					this.fobjList = res || [];
				});
			},
			toGoodDetail(gid) {
				uni.navigateTo({
					url: './gooddetail?gid=' + gid
				});
			},
			goBack() {
				uni.switchTab({ url: '/pages/me/me' });
			}
		},
		watch: {
			searchstr() {
				uni.$u.debounce(() => this.refreshGood(this.activeTypeId), 500);
			}
		},
		computed: {
			...mapState(['userInfo'])
		}
	}
</script>

<style lang="scss" scoped>
.page-container {
	height: 100vh;
	display: flex;
	flex-direction: column;
	background-color: #ffffff;
}

.search-sticky {
	padding: 20rpx 30rpx;
	background-color: #ffffff;
}

.main-content {
	flex: 1;
	display: flex;
	overflow: hidden;
}

.side-bar {
	width: 180rpx;
	height: 100%;
	background-color: #f8fafc;
}

.side-item {
	height: 100rpx;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 26rpx;
	color: #64748b;
	position: relative;
	
	&.active {
		background-color: #ffffff;
		color: #3b82f6;
		font-weight: bold;
		
		&::before {
			content: '';
			position: absolute;
			left: 0;
			top: 30rpx;
			bottom: 30rpx;
			width: 8rpx;
			background-color: #3b82f6;
			border-radius: 0 4rpx 4rpx 0;
		}
	}
}

.good-list-scroll {
	flex: 1;
	height: 100%;
	background-color: #ffffff;
}

.good-grid {
	padding: 20rpx;
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20rpx;
}

.good-item {
	background-color: #ffffff;
	border-radius: 16rpx;
	overflow: hidden;
	box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
	border: 1rpx solid #f1f5f9;
}

.good-img {
	width: 100%;
	height: 200rpx;
	background-color: #f1f5f9;
}

.good-info {
	padding: 16rpx;
}

.good-name {
	font-size: 24rpx;
	font-weight: bold;
	color: #1e293b;
	margin-bottom: 8rpx;
	display: -webkit-box;
	-webkit-box-orient: vertical;
	-webkit-line-clamp: 1;
	overflow: hidden;
}

.price-row {
	display: flex;
	align-items: baseline;
}

.price-val { font-size: 30rpx; font-weight: 800; color: #3b82f6; }
.price-unit { font-size: 20rpx; color: #94a3b8; margin-left: 4rpx; }

.safe-bottom { height: 40rpx; }
</style>
