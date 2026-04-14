<template>
	<view>
		
		<u-navbar title="确认信息" :border="true" :placeholder="true"   :autoBack="true"></u-navbar>
		<scroll-view :enable-flex="true" class="svcontainer">
			<view class="lxrctn">
				<u--form labelPosition="left" ref="fform">
					<view class="formitem">
						<view class="glabel">线路:{{fobj.sname}}</view>
					</view>
					<ideadatetime mode="date" v-model="ydate" label="申请日期"></ideadatetime>
					<view>
						<view class="formitem">
							<u-radio-group v-model="paibanid" placement="column">
								<u-radio :disabled="item.disabled" :customStyle="{marginBottom: '15rpx', marginTop: '15rpx'}" v-for="(item,index) in paibanlist" :key="index" :label="item.shiduan" :name="item.id">
								</u-radio>
							</u-radio-group>
						</view>
					</view>
					<view class="formitem">
						<view class="gtotal">费用:{{fobj.total}}元</view>
					</view>
					<view class="formitem">
						<u-radio-group
								v-model="lxr"
								placement="column"
						>
							<u-radio
									:customStyle="{marginBottom: '15rpx', marginTop: '15rpx'}"
									v-for="(item,index) in lxrList"
									:key="index"
									:label="item.title"
									:name="item.title"
							>
							</u-radio>
						</u-radio-group>
					</view>
				</u--form>

				  <view class="formitem">
					  <u--textarea confirmType="done" v-model="bnote" placeholder="备注信息" ></u--textarea>
				  </view>		
				  
				  <view class="formitem">
				  	<u-button @click="popshow=true" type="primary" text="确定支付"></u-button>
				  </view>
				  
				  <u-popup :closeable="true" @close="popshow=false" :show="popshow" mode="bottom">
				  	<view class="dialogctn">
				  		<u--form>

							<!--
				  			<view class="formitem">
				  				<view style="margin-bottom: 30upx;" class="formlabel">可用优惠券:</view>
				  				<u-radio-group placement="column" @change="toggleTotal">
				  					<u-radio
				  						:customStyle="{marginBottom: '15px'}"
				  						v-for="(item, index) in yhqlist"
				  						:key="index"
				  						:label="item.total>0?'优惠券金额:'+item.total:'无优惠券/不使用'"
				  						:name="item.id"
				  			
				  					>
				  					</u-radio>
				  				</u-radio-group>
				  			</view>
				  			-->
<!--				  			<view class="formitem">
				  				<view class="formlabel">支付金额:<text style="color: red;font-size: 40upx;">{{paytotal}}</text>元</view>
				  			</view>-->
				  			<u-form-item borderBottom label-width="76" label="支付密码:" prop="passwd">
				  				<u--input border="none" type="password" v-model="passwd" />
				  			</u-form-item>
				  			
				  			<view class="formitem">
				  				<button type="primary" @click="payBill()">确认支付</button>
				  			</view>
				  		</u--form>
				  	</view>
				  </u-popup>
				  
			</view>
			
		</scroll-view>
	</view>
</template>

<script>
	import {mapState, mapActions} from 'vuex'
	import { listj, findj, savej, fileUrl } from '@/common/config/api.js';
	import { ideautil } from '@/common/commontools.js';
	export default {
		data() {
			return {
				fobj:null,
				sid:null
			};
		},
		onLoad(params){
			this.sid = params.id
			this.sdid = params.sdid
		},
		onShow(){

		},
		methods: {
			...mapActions(['updateUserInfo']),
			tijiaoBtn(){

			},
			goBack(){
				uni.navigateBack({
					delta:1
				})
			},
			selectedLxr(title){
				this.lxr = title
			},
			
			async yuyueCommit(){
				if(!this.lxr){
					uni.showToast({
						title: '请先添加联系人'
					})
				}
				if(!this.paibanid){
					uni.showToast({
						title: '请选择排班信息'
					})
				}

				findj({params: {table: 'paiban', id:this.paibanid }}).then(paiban => {
					let ycount = paiban.ycount || 0
					ycount = ycount*1+1
					savej({params: {table:"paiban",ycount:ycount,id:paiban.id}}).then(res => {
						let obj = {}
						obj.lxr = this.lxr
						obj.username = this.userInfo.username
						obj.uid = this.userInfo.id
						obj.sid = this.fobj.sid
						obj.shop = this.fobj.shop
						obj.typeid = this.fobj.typeid
						obj.typecn = this.fobj.typecn
						obj.note = this.bnote
						obj.user = obj.username
						obj.statecn = this.statecn
						obj.ydate = this.ydate
						obj.table = 'yuyue'
						obj.total = this.paytotal
						obj.paibanid = this.paibanid
						obj.paiban = paiban.riqi
						obj.shiduan = paiban.shiduan
						obj.shiduanid = paiban.sid
						savej({params: obj}).then(res => {
							/*if (this.statecn == "使用中" && this.yhq) {
                            savej({params: {table: 'youhuiquan', id:this.yhq.id, statecn: "已使用" }})
                        }*/


							uni.showToast({
								title: '操作成功!',
								success:()=>{
									uni.switchTab({
										url: '/pages/yuyue/yuyue'
									})
								}
							})
						})



					})
				})


				
			},
			payBill(){
				let passwd = this.passwd;
				let userpasswd = this.userInfo.passwd
				if(passwd == userpasswd){
					let mymoney = (this.userInfo.money||0)*1
					if (mymoney*1<this.paytotal) {
						uni.showToast({
							icon:'none',
							title: '余额不足!',
							success:()=>{
								setTimeout(()=>{
									this.yuyueCommit()
								},1500)
							}
						})
					}else{
						mymoney = mymoney-this.paytotal
						savej({params: {table: 'user', id: this.userInfo.id, money: mymoney }}).then(res => {
							this.userInfo.money = mymoney
							this.updateUserInfo(this.userInfo)
							this.statecn = '使用中'
							this.yuyueCommit()
						})
					}
					
				}else{
					uni.showToast({
						title: '密码错误',
						icon : 'error'
					})
				}
			},
			getYouhuiquan(){
				listj({params: {table: 'youhuiquan',uid:this.userInfo.id, statecn:"正常" }}).then(yhl => {
					let yhlist = []
					for (let i = 0; i < yhl.length; i++) {
						let yhq = yhl[i]
						if (yhq.total<=this.paytotal) {
							yhlist.push(yhq)
						}
					}
					this.yhqlist = yhlist
					
					this.yhqlist.unshift({id:0,total:0})
				}).catch(err => {
				 
				})
			},
			toggleTotal(n){
				if (n>0) {
					findj({params: {table: 'youhuiquan', id: n}}).then(yhq => {
						this.yhq = yhq
						this.paytotal=this.total-yhq.total
					}).catch(err => {
					 
					})
				}else{
					this.yhq = null
					this.paytotal=this.total
				}
				
				
			}
		},

		computed: {
			...mapState(['userInfo'])
		}
	}
</script>

<style lang="scss">
.lxrctn{
	border-radius: 20upx;
	padding: 10upx;
}
.glabel{
	color: #999;
}
.gtotal{
	color: red;
}
</style>