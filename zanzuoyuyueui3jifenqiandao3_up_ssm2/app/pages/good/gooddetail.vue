<template>
	<view class="page-container">
		<u-navbar title="商品详情" :border="false" :placeholder="true" :autoBack="true" bgColor="#ffffff" titleStyle="font-weight: bold;"></u-navbar>
		
		<scroll-view scroll-y class="content-scroll">
			<!-- 1. 商品大图 -->
			<view class="image-box">
				<image v-if="fobj.img" class="good-banner" :src="fileUrl+fobj.img" mode="aspectFill"></image>
			</view>

			<!-- 2. 价格与标题卡片 -->
			<view class="info-card">
				<view class="price-section">
					<text class="price-symbol">💎</text>
					<text class="price-num">{{ fobj.price }}</text>
					<text class="price-label">积分</text>
				</view>
				<view class="title-section">
					<text class="good-title">{{ fobj.gname }}</text>
					<text class="good-type">{{ fobj.type }}</text>
				</view>
			</view>

			<!-- 3. 详情内容 -->
			<view class="detail-card">
				<view class="section-header">
					<view class="title-line"></view>
					<text class="section-title">饰品介绍</text>
				</view>
				<view class="detail-content">
					<u-parse :content="fobj.note" />
				</view>
			</view>

			<!-- 4. 评价区域 -->
			<view class="detail-card">
				<view class="section-header">
					<view class="title-line"></view>
					<text class="section-title">兑换评价 ({{ replaylist.length }})</text>
				</view>
				
				<view v-if="replaylist.length > 0" class="comment-list">
					<view v-for="(item, index) in replaylist" :key="index" class="comment-item">
						<view class="comment-user">
							<text class="u-name">{{ item.username }}</text>
							<text class="u-date">{{ item.ndate }}</text>
						</view>
						<view class="comment-note">{{ item.note }}</view>
					</view>
				</view>


				<!-- 评价输入 -->
				<view class="write-comment" v-show="showpl">
					<view class="rate-box">
						<text>满意度：</text>
						<tn-rate v-model="pingfen" :size="40" activeColor="#3b82f6"></tn-rate>
					</view>
					<view class="input-box">
						<tn-input v-model="rnote" type="textarea" placeholder="说说你的兑换体验吧..." :border="false" :height="160" />
					</view>
					<u-button @click="replay()" type="primary" shape="circle" customStyle="margin-top: 20rpx;">提交评价</u-button>
				</view>
			</view>

			<view class="safe-bottom"></view>
		</scroll-view>

		<!-- 底部操作栏 -->
		<view class="bottom-action">
			<view class="action-btn-group">
				<view class="fav-btn" @click="toggleFav">
					<text :class="['icon', isFav ? 'fav-active' : '']">{{ isFav ? '❤️' : '🤍' }}</text>
					<text>{{ isFav ? '已收藏' : '收藏' }}</text>
				</view>
				<view class="buy-btn" @click="goumai">
					<text>立即兑换</text>
				</view>
			</view>
		</view>

		<tn-tips ref="tips"></tn-tips>
	</view>
</template>

<script>
	import { savej, listj, findj, fileUrl } from '@/common/config/api.js'
	import { mapState, mapActions } from 'vuex'
	import { ideautil } from '@/common/commontools.js'
	
	export default {
		data() {
			return {
				gid: null,
				fileUrl: fileUrl,
				fobj: {},
				replaylist: [],
				rnote: '',
				pingfen: 0,
				showpl: false,
				isFav: false
			};
		},
		onLoad(params) {
			this.gid = params.gid
			if (params.showpl == 1) {
				this.showpl = true
			}
			this.fetchDetail()
		},
		methods: {
			...mapActions(['setCar']),
			fetchDetail() {
				findj({params: {table: 'good', id: this.gid}}).then(res => {
					this.fobj = res
					this.fobj.note = ideautil.getHtmlNote(this.fobj.note)
					this.checkFavs()
					this.listReplay()
				});
			},
			listReplay() {
				listj({params: {table: 'replay', pid: this.fobj.id, type: 1}}).then(res => {
					this.replaylist = res || []
				});
			},
			toggleFav() {
				let myfavs = this.userInfo.favs || ""
				if (!this.isFav) {
					myfavs = myfavs ? (myfavs + "," + this.fobj.id) : (this.fobj.id + "")
				} else {
					myfavs = ideautil.removeStrInStr(this.fobj.id, myfavs) || "0"
				}
				
				savej({ params: { table: "user", favs: myfavs, id: this.userInfo.id } }).then(() => {
					this.userInfo.favs = myfavs
					this.checkFavs()
					uni.showToast({ icon: 'none', title: this.isFav ? '收藏成功' : '取消收藏' })
				});
			},
			checkFavs() {
				let myfavs = this.userInfo.favs || ""
				this.isFav = ideautil.checkStrInStr(this.fobj.id + "", myfavs)
			},
			goumai() {
				this.fobj.count = 1
				this.fobj.checked = true
				this.setCar([this.fobj])
				uni.navigateTo({
					url: '/pages/bill/surebill'
				})
			},
			replay() {
				if (!this.rnote) {
					uni.showToast({ icon: 'none', title: '请输入内容' });
					return;
				}
				let fdata = {
					table: "replay",
					pid: this.fobj.id,
					note: this.rnote,
					uid: this.userInfo.id,
					username: this.userInfo.username,
					type: 1,
					ndate: ideautil.getNowStr()
				}
				savej({params: fdata}).then(() => {
					this.listReplay()
					this.showpl = false
					this.rnote = ''
					uni.showToast({ title: '评价成功' })
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
	background-color: #f8fafc;
}

.content-scroll {
	height: calc(100vh - 44px - 120rpx);
}

.image-box {
	width: 100%;
	height: 560rpx;
	background-color: #ffffff;
}

.good-banner {
	width: 100%;
	height: 100%;
}

.info-card {
	margin: -40rpx 24rpx 24rpx;
	background-color: #ffffff;
	border-radius: 32rpx;
	padding: 40rpx;
	box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.04);
	position: relative;
	z-index: 2;
}

.price-section {
	display: flex;
	align-items: baseline;
	margin-bottom: 20rpx;
}

.price-symbol { font-size: 32rpx; margin-right: 8rpx; }
.price-num { font-size: 48rpx; font-weight: 800; color: #3b82f6; }
.price-label { font-size: 24rpx; color: #64748b; margin-left: 8rpx; }

.good-title {
	font-size: 36rpx;
	font-weight: bold;
	color: #1e293b;
	display: block;
	margin-bottom: 16rpx;
}

.good-type {
	display: inline-block;
	font-size: 22rpx;
	color: #3b82f6;
	background-color: #eff6ff;
	padding: 6rpx 20rpx;
	border-radius: 100rpx;
}

.detail-card {
	margin: 0 24rpx 24rpx;
	background-color: #ffffff;
	border-radius: 24rpx;
	padding: 30rpx;
}

.section-header {
	display: flex;
	align-items: center;
	margin-bottom: 30rpx;
}

.title-line {
	width: 8rpx;
	height: 32rpx;
	background: #3b82f6;
	border-radius: 4rpx;
	margin-right: 16rpx;
}

.section-title {
	font-size: 30rpx;
	font-weight: bold;
	color: #1e293b;
}

.detail-content {
	font-size: 28rpx;
	color: #475569;
	line-height: 1.6;
}

.comment-list {
	padding: 10rpx 0;
}

.comment-item {
	padding: 24rpx 0;
	border-bottom: 1rpx solid #f1f5f9;
	&:last-child { border-bottom: none; }
}

.comment-user {
	display: flex;
	justify-content: space-between;
	margin-bottom: 12rpx;
}

.u-name { font-size: 26rpx; font-weight: bold; color: #334155; }
.u-date { font-size: 22rpx; color: #94a3b8; }
.comment-note { font-size: 26rpx; color: #64748b; }

.write-comment {
	margin-top: 30rpx;
	padding: 30rpx;
	background-color: #f8fafc;
	border-radius: 20rpx;
}

.rate-box {
	display: flex;
	align-items: center;
	margin-bottom: 20rpx;
	font-size: 26rpx;
	color: #64748b;
}

.input-box {
	background-color: #ffffff;
	border-radius: 12rpx;
	padding: 10rpx;
}

.bottom-action {
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 120rpx;
	background-color: #ffffff;
	padding: 16rpx 30rpx;
	padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
	box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
	z-index: 10;
}

.action-btn-group {
	display: flex;
	align-items: center;
	gap: 30rpx;
	height: 88rpx;
}

.fav-btn {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	width: 100rpx;
	font-size: 20rpx;
	color: #64748b;
	.icon { font-size: 36rpx; margin-bottom: 4rpx; }
	.fav-active { color: #ef4444; }
}

.buy-btn {
	flex: 1;
	height: 88rpx;
	background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
	color: #ffffff;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 100rpx;
	font-size: 30rpx;
	font-weight: bold;
	box-shadow: 0 8rpx 16rpx rgba(37, 99, 235, 0.2);
	&:active { opacity: 0.9; }
}

.safe-bottom { height: 60rpx; }
</style>
