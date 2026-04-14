<template>
	<view>
		<u-navbar title="扫码" leftIconSize="0" :border="true" :placeholder="true" @leftClick="goBack" :autoBack="false"></u-navbar>

	</view>
</template>

<script>
	import {
		listj,
		findj,
		savej,
		listSqlj,
		deletej,
		fileUrl
	} from '@/common/config/api.js';
	import { ideautil, yewuutil } from '@/common/commontools.js';
	import {
		mapState,
		mapActions
	} from 'vuex'
	export default {
		data() {
			return {

			};
		},
		onLoad(params) {


		},
		onShow(){
			this.saoyisao()
		},
		methods: {
			...mapActions(['updateUserInfo']),
			saoyisao(){
				//this.changeBillStatecn("已签到")
				uni.itool.saoyisao((id)=>{
					if(id == this.fobj.siteid){
						this.changeBillStatecn("已签到")
					}else{
						uni.showToast({
							icon:'none',
							title: '座位号不对'
						})
					}

				})
			}
		},
		computed: {
			...mapState(['userInfo'])
		}
	}
</script>

<style lang="scss">
	.caritem {
		display: flex;
		width: 100%;
		height: 200upx;
		background-color: #fafafa;
		align-items: center;
		padding: 10upx;
		margin: 10upx 0;
	}

	.carimg {
		width: 180upx;
		height: 180upx;
		margin-right: 10upx;
	}

	.carinfo {
		height: 100%;
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		flex: 1;
	}

	.cartitle {
		font-size: 26upx;
	}

	.carpricectn {
		display: flex;
		justify-content: space-between;
		width: 100%;
	}

	.carprice {
		color: red;
		font-size: 25upx;
	}
</style>
