<!-- 蓝色登录页面2 -->
<template>
	<view class="container">
		<!-- 隐藏的配置入口 -->
		<navigator class="config-entry" url="/pages/login/rootip" open-type="redirect"></navigator>

		<!-- 顶部背景与欢迎词 -->
		<view class="header-section">
			<view class="welcome-box">
				<text class="emoji-logo">👋</text>
				<view class="welcome-text">
					<text class="title">您好，</text>
					<text class="subtitle">欢迎回来</text>
				</view>
			</view>
		</view>

		<!-- 登录卡片 -->
		<view class="login-card">
			<view class="card-header">
				<text class="card-title">账号登录</text>
				<view class="title-line"></view>
			</view>

			<form class="login-form">
				<view class="input-group">
					<text class="input-icon">👤</text>
					<input 
						type="text" 
						name="username" 
						placeholder="请输入用户名" 
						v-model="username" 
						placeholder-class="placeholder-style"
					/>
				</view>

				<view class="input-group">
					<text class="input-icon">🔒</text>
					<input 
						type="password" 
						name="passwd" 
						placeholder="请输入密码"
            :password="true"
						v-model="passwd" 
						placeholder-class="placeholder-style"
					/>
				</view>

				<button class="login-btn" @tap="handLogin()">登 录</button>
				
				<view class="footer-actions">
					<text class="reg-text" @tap="toReg()">还没有账号？立即注册</text>
				</view>
			</form>

			<!-- #ifdef MP-WEIXIN -->
			<view class="social-login">
				<view class="divider">
					<view class="line"></view>
					<text class="divider-text">其他登录方式</text>
					<view class="line"></view>
				</view>
				
				<view class="social-icons">
					<view class="icon-item" @tap="getUserInfos()">
						<text class="social-emoji">💬</text>
						<text class="icon-label">微信</text>
					</view>
					<!-- QQ登录暂不开启或仅作展示 -->
					<view class="icon-item grayscale">
						<text class="social-emoji">🐧</text>
						<text class="icon-label">QQ</text>
					</view>
				</view>
			</view>
			<!-- #endif -->
		</view>
		
		<view class="bottom-tips">
			<text>登录即代表同意用户协议与隐私政策</text>
		</view>
	</view>
</template>

<script>
import { savej, listj, findj, fileUrl, serverUrl } from '@/common/config/api.js'
import { mapState, mapActions } from 'vuex'

export default {
	data() {
		return {
			username: '', //用户名
			passwd: '', //密码
			serverUrl: serverUrl,
			open_id: '',
			session_key: '',
			code: ''
		};
	},
	onLoad() {
		this.username = this.userInfo && this.userInfo.username
		this.passwd = this.userInfo && this.userInfo.passwd
		if (this.username && this.passwd) {
			this.handLogin()
		}
	},
	methods: {
		...mapActions(['updateUserInfo', 'logout']),
		toReg() {
			uni.redirectTo({
				url: './register'
			})
		},
		getUserInfos(e) {
			console.log('getUserProfile--------------------------------')
			uni.showLoading({
				title: '微信登录中...',
				mask: true
			});
			uni.getUserProfile({
				provider: 'weixin',
				desc: '获取用户信息以完善个人资料',
				lang: 'zh_CN',
				success: (e) => {
					console.log('getUserProfile success', e)
					this.wechatLogin()
				},
				fail: (err) => {
					console.error('getUserProfile fail', err)
					uni.hideLoading()
					uni.showToast({
						title: '取消授权',
						icon: 'none'
					})
				}
			})
		},
		wechatLogin() {
			uni.login({
				provider: 'weixin',
				success: (loginRes) => {
					let code = loginRes.code;
					uni.request({
						url: this.serverUrl + "wxlogin",
						data: {
							code
						},
						success: (res) => {
							if (res.statusCode == 200) {
								console.info("wechatLogin success")
								this.open_id = res.data.openid
								this.session_key = res.data.session_key
								console.info(`openid:${this.open_id} sesskey:${this.session_key}`)
								this.handLogin()
							} else {
								uni.hideLoading()
								uni.showToast({
									title: '登录失败',
									icon: 'none'
								})
							}
						},
						fail: () => {
							uni.hideLoading()
						}
					})
				},
				fail: () => {
					uni.hideLoading()
				}
			});
		},
		handLogin() {
			console.log('------------------>handLogin')
			uni.showLoading({
				title: '登录中...',
				mask: true
			});
			
			if (this.open_id) {
				console.log('------------------>handLogin:使用openid登录:' + this.open_id)
				findj({
					params: {
						table: 'user',
						openid: this.open_id
					}
				}).then(res => {
					uni.hideLoading()
					if (res) {
						this.loginSuccess(res);
					} else {
						savej({
							params: {
								table: "user",
								openid: this.open_id,
								roletype: "2"
							}
						}).then(resId => {
							if (resId) {
								let userobj = {
									id: resId,
									openid: this.open_id
								}
								this.loginSuccess(userobj);
							}
						}).catch(err => {
							uni.hideLoading()
						})
					}
				}).catch(err => {
					uni.hideLoading()
				})
			} else {
				console.log('------------------>handLogin:用户名密码登录:')
				if (this.username && this.passwd) {
					findj({
						params: {
							table: 'user',
							username: this.username,
							passwd: this.passwd
						}
					}).then(res => {
						uni.hideLoading()
						if (res) {
							this.loginSuccess(res)
						} else {
							uni.showToast({
								title: '用户名或密码错误',
								icon: 'error'
							})
						}
					}).catch(err => {
						console.error(err)
						uni.hideLoading()
					})
				} else {
					uni.hideLoading()
					uni.showToast({
						icon: 'none',
						title: '请输入账号和密码'
					})
				}
			}
		},
		loginSuccess(userobj) {
			uni.hideLoading()
			console.info('Login success:', JSON.stringify(userobj))
			this.updateUserInfo(userobj)
			uni.showToast({
				title: '登录成功',
				icon: 'success'
			})
			setTimeout(() => {
				uni.ytool.toIndex()
			}, 800);
		}
	},
	computed: {
		...mapState(['userInfo'])
	}
};
</script>

<style lang="scss" scoped>
.container {
	min-height: 100vh;
	background-color: #F8FAFC;
	position: relative;
	display: flex;
	flex-direction: column;
}

.config-entry {
	height: 80rpx;
	width: 80rpx;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 100;
}

.header-section {
	height: 400rpx;
	background: linear-gradient(135deg, #3A7BD5 0%, #00D2FF 100%);
	display: flex;
	align-items: center;
	padding: 0 60rpx;
	border-bottom-right-radius: 80rpx;
	
	.welcome-box {
		display: flex;
		align-items: center;
		margin-top: -40rpx;
		
		.emoji-logo {
			font-size: 80rpx;
			margin-right: 30rpx;
			background: rgba(255, 255, 255, 0.2);
			padding: 20rpx;
			border-radius: 30rpx;
			backdrop-filter: blur(10px);
		}
		
		.welcome-text {
			display: flex;
			flex-direction: column;
			color: #FFFFFF;
			
			.title {
				font-size: 48rpx;
				font-weight: bold;
				margin-bottom: 8rpx;
			}
			
			.subtitle {
				font-size: 32rpx;
				opacity: 0.9;
			}
		}
	}
}

.login-card {
	margin: -80rpx 40rpx 0;
	background-color: #FFFFFF;
	border-radius: 40rpx;
	padding: 60rpx 40rpx;
	box-shadow: 0 20rpx 40rpx rgba(0, 0, 0, 0.05);
	flex: 1;
	
	.card-header {
		margin-bottom: 60rpx;
		
		.card-title {
			font-size: 36rpx;
			font-weight: bold;
			color: #1E293B;
		}
		
		.title-line {
			width: 60rpx;
			height: 6rpx;
			background-color: #3A7BD5;
			margin-top: 12rpx;
			border-radius: 3rpx;
		}
	}
}

.input-group {
	display: flex;
	align-items: center;
	background-color: #F1F5F9;
	border-radius: 20rpx;
	padding: 0 30rpx;
	margin-bottom: 30rpx;
	height: 110rpx;
	transition: all 0.3s;
	border: 2rpx solid transparent;
	
	&:focus-within {
		background-color: #FFFFFF;
		border-color: #3A7BD5;
		box-shadow: 0 0 0 4rpx rgba(58, 123, 213, 0.1);
	}
	
	.input-icon {
		font-size: 40rpx;
		margin-right: 20rpx;
	}
	
	input {
		flex: 1;
		height: 100%;
		font-size: 30rpx;
		color: #1E293B;
	}
}

.placeholder-style {
	color: #94A3B8;
}

.login-btn {
	width: 100%;
	height: 110rpx;
	line-height: 110rpx;
	background: linear-gradient(90deg, #3A7BD5 0%, #00D2FF 100%);
	color: #FFFFFF;
	font-size: 32rpx;
	font-weight: bold;
	border-radius: 55rpx;
	margin-top: 50rpx;
	border: none;
	box-shadow: 0 10rpx 20rpx rgba(58, 123, 213, 0.2);
	
	&:active {
		transform: scale(0.98);
		opacity: 0.9;
	}
}

.footer-actions {
	margin-top: 40rpx;
	text-align: center;
	
	.reg-text {
		font-size: 28rpx;
		color: #64748B;
		
		&:active {
			color: #3A7BD5;
		}
	}
}

.social-login {
	margin-top: 80rpx;
	
	.divider {
		display: flex;
		align-items: center;
		justify-content: center;
		margin-bottom: 40rpx;
		
		.line {
			flex: 1;
			height: 1rpx;
			background-color: #E2E8F0;
		}
		
		.divider-text {
			font-size: 24rpx;
			color: #94A3B8;
			margin: 0 30rpx;
		}
	}
	
	.social-icons {
		display: flex;
		justify-content: center;
		gap: 80rpx;
		
		.icon-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			
			.social-emoji {
				font-size: 60rpx;
				margin-bottom: 12rpx;
				background-color: #F8FAFC;
				width: 100rpx;
				height: 100rpx;
				display: flex;
				align-items: center;
				justify-content: center;
				border-radius: 50%;
				border: 2rpx solid #E2E8F0;
				transition: all 0.2s;
				
				&:active {
					background-color: #F1F5F9;
					border-color: #3A7BD5;
				}
			}
			
			.icon-label {
				font-size: 24rpx;
				color: #64748B;
			}
			
			&.grayscale {
				opacity: 0.5;
				filter: grayscale(1);
			}
		}
	}
}

.bottom-tips {
	padding: 40rpx;
	text-align: center;
	
	text {
		font-size: 24rpx;
		color: #94A3B8;
	}
}

/* 响应式调整 - Web端 */
@media screen and (min-width: 768px) {
	.container {
		background-color: #F1F5F9;
		justify-content: center;
		align-items: center;
	}
	
	.header-section {
		width: 800rpx;
		height: 300rpx;
		border-radius: 40rpx 40rpx 0 0;
	}
	
	.login-card {
		width: 800rpx;
		margin-top: -60rpx;
		box-sizing: border-box;
		border-radius: 0 0 40rpx 40rpx;
		flex: none;
	}
	
	.bottom-tips {
		width: 800rpx;
		box-sizing: border-box;
	}
}
</style>
