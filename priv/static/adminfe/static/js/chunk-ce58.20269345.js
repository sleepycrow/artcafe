(window.webpackJsonp=window.webpackJsonp||[]).push([["chunk-ce58"],{"+c4Y":function(t,s,e){},"4bFr":function(t,s,e){"use strict";e.r(s);var a={name:"UsersShow",components:{Status:e("ot3S").a},data:function(){return{showPrivate:!1}},computed:{statuses:function(){return this.$store.state.userProfile.statuses},statusesLoading:function(){return this.$store.state.userProfile.statusesLoading},user:function(){return this.$store.state.userProfile.user},userProfileLoading:function(){return this.$store.state.userProfile.userProfileLoading}},mounted:function(){this.$store.dispatch("FetchUserProfile",{userId:this.$route.params.id,godmode:!1})},methods:{onTogglePrivate:function(){this.$store.dispatch("FetchUserProfile",{userId:this.$route.params.id,godmode:this.showPrivate})}}},r=(e("cV64"),e("KHd+")),n=Object(r.a)(a,function(){var t=this,s=t.$createElement,e=t._self._c||s;return t.userProfileLoading?t._e():e("main",[e("header",[e("el-avatar",{attrs:{src:t.user.avatar,size:"large"}}),t._v(" "),e("h1",[t._v(t._s(t.user.display_name))])],1),t._v(" "),e("el-row",[e("el-col",{attrs:{span:8}},[e("el-card",{staticClass:"user-profile-card"},[e("div",{staticClass:"el-table el-table--fit el-table--enable-row-hover el-table--enable-row-transition el-table--medium"},[e("table",{staticClass:"user-profile-table"},[e("tbody",[e("tr",{staticClass:"el-table__row"},[e("td",[t._v(t._s(t.$t("userProfile.nickname")))]),t._v(" "),e("td",[t._v("\n                  "+t._s(t.user.nickname)+"\n                ")])]),t._v(" "),e("tr",{staticClass:"el-table__row"},[e("td",{staticClass:"name-col"},[t._v("ID")]),t._v(" "),e("td",{staticClass:"value-col"},[t._v("\n                  "+t._s(t.user.id)+"\n                ")])]),t._v(" "),e("tr",{staticClass:"el-table__row"},[e("td",[t._v(t._s(t.$t("userProfile.tags")))]),t._v(" "),e("td",[t._l(t.user.tags,function(s){return e("el-tag",{key:s,staticClass:"user-profile-tag"},[t._v(t._s(s))])}),t._v(" "),0===t.user.tags.length?e("span",[t._v("—")]):t._e()],2)]),t._v(" "),e("tr",{staticClass:"el-table__row"},[e("td",[t._v(t._s(t.$t("userProfile.roles")))]),t._v(" "),e("td",[t.user.roles.admin?e("el-tag",{staticClass:"user-profile-tag"},[t._v("\n                    "+t._s(t.$t("users.admin"))+"\n                  ")]):t._e(),t._v(" "),t.user.roles.moderator?e("el-tag",{staticClass:"user-profile-tag"},[t._v("\n                    "+t._s(t.$t("users.moderator"))+"\n                  ")]):t._e(),t._v(" "),t.user.roles.moderator||t.user.roles.admin?t._e():e("span",[t._v("—")])],1)]),t._v(" "),e("tr",{staticClass:"el-table__row"},[e("td",[t._v(t._s(t.$t("userProfile.localUppercase")))]),t._v(" "),e("td",[t.user.local?e("el-tag",{attrs:{type:"info"}},[t._v(t._s(t.$t("userProfile.local")))]):t._e(),t._v(" "),t.user.local?t._e():e("el-tag",{attrs:{type:"info"}},[t._v(t._s(t.$t("userProfile.external")))])],1)]),t._v(" "),e("tr",{staticClass:"el-table__row"},[e("td",[t._v(t._s(t.$t("userProfile.activeUppercase")))]),t._v(" "),e("td",[t.user.deactivated?e("el-tag",{attrs:{type:"success"}},[t._v(t._s(t.$t("userProfile.active")))]):t._e(),t._v(" "),t.user.deactivated?t._e():e("el-tag",{attrs:{type:"danger"}},[t._v(t._s(t.$t("userProfile.deactivated")))])],1)])])])])])],1),t._v(" "),e("el-row",{staticClass:"row-bg",attrs:{type:"flex",justify:"space-between"}},[e("el-col",{attrs:{span:18}},[e("h2",{staticClass:"recent-statuses"},[t._v(t._s(t.$t("userProfile.recentStatuses")))])]),t._v(" "),e("el-col",{staticClass:"show-private",attrs:{span:6}},[e("el-checkbox",{on:{change:t.onTogglePrivate},model:{value:t.showPrivate,callback:function(s){t.showPrivate=s},expression:"showPrivate"}},[t._v("\n          "+t._s(t.$t("userProfile.showPrivateStatuses"))+"\n        ")])],1)],1),t._v(" "),e("el-col",{attrs:{span:16}},[t.statusesLoading?t._e():e("el-timeline",{staticClass:"statuses"},[t._l(t.statuses,function(s){return e("el-timeline-item",{key:s.id},[e("status",{attrs:{status:s,"user-id":t.user.id,godmode:t.showPrivate}})],1)}),t._v(" "),0===t.statuses.length?e("p",{staticClass:"no-statuses"},[t._v(t._s(t.$t("userProfile.noStatuses")))]):t._e()],2)],1)],1)],1)},[],!1,null,"1966c214",null);n.options.__file="show.vue";s.default=n.exports},Kw8l:function(t,s,e){"use strict";var a=e("cRgN");e.n(a).a},RnhZ:function(t,s,e){var a={"./af":"K/tc","./af.js":"K/tc","./ar":"jnO4","./ar-dz":"o1bE","./ar-dz.js":"o1bE","./ar-kw":"Qj4J","./ar-kw.js":"Qj4J","./ar-ly":"HP3h","./ar-ly.js":"HP3h","./ar-ma":"CoRJ","./ar-ma.js":"CoRJ","./ar-sa":"gjCT","./ar-sa.js":"gjCT","./ar-tn":"bYM6","./ar-tn.js":"bYM6","./ar.js":"jnO4","./az":"SFxW","./az.js":"SFxW","./be":"H8ED","./be.js":"H8ED","./bg":"hKrs","./bg.js":"hKrs","./bm":"p/rL","./bm.js":"p/rL","./bn":"kEOa","./bn.js":"kEOa","./bo":"0mo+","./bo.js":"0mo+","./br":"aIdf","./br.js":"aIdf","./bs":"JVSJ","./bs.js":"JVSJ","./ca":"1xZ4","./ca.js":"1xZ4","./cs":"PA2r","./cs.js":"PA2r","./cv":"A+xa","./cv.js":"A+xa","./cy":"l5ep","./cy.js":"l5ep","./da":"DxQv","./da.js":"DxQv","./de":"tGlX","./de-at":"s+uk","./de-at.js":"s+uk","./de-ch":"u3GI","./de-ch.js":"u3GI","./de.js":"tGlX","./dv":"WYrj","./dv.js":"WYrj","./el":"jUeY","./el.js":"jUeY","./en-SG":"zavE","./en-SG.js":"zavE","./en-au":"Dmvi","./en-au.js":"Dmvi","./en-ca":"OIYi","./en-ca.js":"OIYi","./en-gb":"Oaa7","./en-gb.js":"Oaa7","./en-ie":"4dOw","./en-ie.js":"4dOw","./en-il":"czMo","./en-il.js":"czMo","./en-nz":"b1Dy","./en-nz.js":"b1Dy","./eo":"Zduo","./eo.js":"Zduo","./es":"iYuL","./es-do":"CjzT","./es-do.js":"CjzT","./es-us":"Vclq","./es-us.js":"Vclq","./es.js":"iYuL","./et":"7BjC","./et.js":"7BjC","./eu":"D/JM","./eu.js":"D/JM","./fa":"jfSC","./fa.js":"jfSC","./fi":"gekB","./fi.js":"gekB","./fo":"ByF4","./fo.js":"ByF4","./fr":"nyYc","./fr-ca":"2fjn","./fr-ca.js":"2fjn","./fr-ch":"Dkky","./fr-ch.js":"Dkky","./fr.js":"nyYc","./fy":"cRix","./fy.js":"cRix","./ga":"USCx","./ga.js":"USCx","./gd":"9rRi","./gd.js":"9rRi","./gl":"iEDd","./gl.js":"iEDd","./gom-latn":"DKr+","./gom-latn.js":"DKr+","./gu":"4MV3","./gu.js":"4MV3","./he":"x6pH","./he.js":"x6pH","./hi":"3E1r","./hi.js":"3E1r","./hr":"S6ln","./hr.js":"S6ln","./hu":"WxRl","./hu.js":"WxRl","./hy-am":"1rYy","./hy-am.js":"1rYy","./id":"UDhR","./id.js":"UDhR","./is":"BVg3","./is.js":"BVg3","./it":"bpih","./it-ch":"bxKX","./it-ch.js":"bxKX","./it.js":"bpih","./ja":"B55N","./ja.js":"B55N","./jv":"tUCv","./jv.js":"tUCv","./ka":"IBtZ","./ka.js":"IBtZ","./kk":"bXm7","./kk.js":"bXm7","./km":"6B0Y","./km.js":"6B0Y","./kn":"PpIw","./kn.js":"PpIw","./ko":"Ivi+","./ko.js":"Ivi+","./ku":"JCF/","./ku.js":"JCF/","./ky":"lgnt","./ky.js":"lgnt","./lb":"RAwQ","./lb.js":"RAwQ","./lo":"sp3z","./lo.js":"sp3z","./lt":"JvlW","./lt.js":"JvlW","./lv":"uXwI","./lv.js":"uXwI","./me":"KTz0","./me.js":"KTz0","./mi":"aIsn","./mi.js":"aIsn","./mk":"aQkU","./mk.js":"aQkU","./ml":"AvvY","./ml.js":"AvvY","./mn":"lYtQ","./mn.js":"lYtQ","./mr":"Ob0Z","./mr.js":"Ob0Z","./ms":"6+QB","./ms-my":"ZAMP","./ms-my.js":"ZAMP","./ms.js":"6+QB","./mt":"G0Uy","./mt.js":"G0Uy","./my":"honF","./my.js":"honF","./nb":"bOMt","./nb.js":"bOMt","./ne":"OjkT","./ne.js":"OjkT","./nl":"+s0g","./nl-be":"2ykv","./nl-be.js":"2ykv","./nl.js":"+s0g","./nn":"uEye","./nn.js":"uEye","./pa-in":"8/+R","./pa-in.js":"8/+R","./pl":"jVdC","./pl.js":"jVdC","./pt":"8mBD","./pt-br":"0tRk","./pt-br.js":"0tRk","./pt.js":"8mBD","./ro":"lyxo","./ro.js":"lyxo","./ru":"lXzo","./ru.js":"lXzo","./sd":"Z4QM","./sd.js":"Z4QM","./se":"//9w","./se.js":"//9w","./si":"7aV9","./si.js":"7aV9","./sk":"e+ae","./sk.js":"e+ae","./sl":"gVVK","./sl.js":"gVVK","./sq":"yPMs","./sq.js":"yPMs","./sr":"zx6S","./sr-cyrl":"E+lV","./sr-cyrl.js":"E+lV","./sr.js":"zx6S","./ss":"Ur1D","./ss.js":"Ur1D","./sv":"X709","./sv.js":"X709","./sw":"dNwA","./sw.js":"dNwA","./ta":"PeUW","./ta.js":"PeUW","./te":"XLvN","./te.js":"XLvN","./tet":"V2x9","./tet.js":"V2x9","./tg":"Oxv6","./tg.js":"Oxv6","./th":"EOgW","./th.js":"EOgW","./tl-ph":"Dzi0","./tl-ph.js":"Dzi0","./tlh":"z3Vd","./tlh.js":"z3Vd","./tr":"DoHr","./tr.js":"DoHr","./tzl":"z1FC","./tzl.js":"z1FC","./tzm":"wQk9","./tzm-latn":"tT3J","./tzm-latn.js":"tT3J","./tzm.js":"wQk9","./ug-cn":"YRex","./ug-cn.js":"YRex","./uk":"raLr","./uk.js":"raLr","./ur":"UpQW","./ur.js":"UpQW","./uz":"Loxo","./uz-latn":"AQ68","./uz-latn.js":"AQ68","./uz.js":"Loxo","./vi":"KSF8","./vi.js":"KSF8","./x-pseudo":"/X5v","./x-pseudo.js":"/X5v","./yo":"fzPg","./yo.js":"fzPg","./zh-cn":"XDpg","./zh-cn.js":"XDpg","./zh-hk":"SatO","./zh-hk.js":"SatO","./zh-tw":"kOpN","./zh-tw.js":"kOpN"};function r(t){var s=n(t);return e(s)}function n(t){if(!e.o(a,t)){var s=new Error("Cannot find module '"+t+"'");throw s.code="MODULE_NOT_FOUND",s}return a[t]}r.keys=function(){return Object.keys(a)},r.resolve=n,t.exports=r,r.id="RnhZ"},cRgN:function(t,s,e){},cV64:function(t,s,e){"use strict";var a=e("+c4Y");e.n(a).a},ot3S:function(t,s,e){"use strict";var a=e("wd/R"),r=e.n(a),n={name:"Status",props:{status:{type:Object,required:!0},page:{type:Number,required:!1,default:0},userId:{type:String,required:!1,default:""},godmode:{type:Boolean,required:!1,default:!1}},data:function(){return{showHiddenStatus:!1}},methods:{capitalizeFirstLetter:function(t){return t.charAt(0).toUpperCase()+t.slice(1)},changeStatus:function(t,s,e){this.$store.dispatch("ChangeStatusScope",{statusId:t,isSensitive:s,visibility:e,reportCurrentPage:this.page,userId:this.userId,godmode:this.godmode})},deleteStatus:function(t){var s=this;this.$confirm("Are you sure you want to delete this status?","Warning",{confirmButtonText:"OK",cancelButtonText:"Cancel",type:"warning"}).then(function(){s.$store.dispatch("DeleteStatus",{statusId:t,reportCurrentPage:s.page,userId:s.userId,godmode:s.godmode}),s.$message({type:"success",message:"Delete completed"})}).catch(function(){s.$message({type:"info",message:"Delete canceled"})})},optionPercent:function(t,s){var e=t.options.reduce(function(t,s){return t+s.votes_count},0);return 0===e?0:+(s.votes_count/e*100).toFixed(1)},parseTimestamp:function(t){return r()(t).format("YYYY-MM-DD HH:mm")}}},i=(e("Kw8l"),e("KHd+")),o=Object(i.a)(n,function(){var t=this,s=t.$createElement,e=t._self._c||s;return e("div",[t.status.deleted?e("el-card",{staticClass:"status-card"},[e("div",{attrs:{slot:"header"},slot:"header"},[e("div",{staticClass:"status-header"},[e("div",{staticClass:"status-account-container"},[e("div",{staticClass:"status-account"},[e("h4",{staticClass:"status-deleted"},[t._v(t._s(t.$t("reports.statusDeleted")))])])])])]),t._v(" "),e("div",{staticClass:"status-body"},[t.status.content?e("span",{staticClass:"status-content",domProps:{innerHTML:t._s(t.status.content)}}):e("span",{staticClass:"status-without-content"},[t._v("no content")])]),t._v(" "),t.status.created_at?e("a",{staticClass:"account",attrs:{href:t.status.url,target:"_blank"}},[t._v("\n      "+t._s(t.parseTimestamp(t.status.created_at))+"\n    ")]):t._e()]):e("el-card",{staticClass:"status-card"},[e("div",{attrs:{slot:"header"},slot:"header"},[e("div",{staticClass:"status-header"},[e("div",{staticClass:"status-account-container"},[e("div",{staticClass:"status-account"},[e("img",{staticClass:"status-avatar-img",attrs:{src:t.status.account.avatar}}),t._v(" "),e("h3",{staticClass:"status-account-name"},[t._v(t._s(t.status.account.display_name))])]),t._v(" "),e("a",{staticClass:"account",attrs:{href:t.status.account.url,target:"_blank"}},[t._v("\n            @"+t._s(t.status.account.acct)+"\n          ")])]),t._v(" "),e("div",{staticClass:"status-actions"},[t.status.sensitive?e("el-tag",{attrs:{type:"warning",size:"large"}},[t._v(t._s(t.$t("reports.sensitive")))]):t._e(),t._v(" "),e("el-tag",{attrs:{size:"large"}},[t._v(t._s(t.capitalizeFirstLetter(t.status.visibility)))]),t._v(" "),e("el-dropdown",{attrs:{trigger:"click"}},[e("el-button",{staticClass:"status-actions-button",attrs:{plain:"",size:"small",icon:"el-icon-edit"}},[t._v("\n              "+t._s(t.$t("reports.changeScope"))),e("i",{staticClass:"el-icon-arrow-down el-icon--right"})]),t._v(" "),e("el-dropdown-menu",{attrs:{slot:"dropdown"},slot:"dropdown"},[t.status.sensitive?t._e():e("el-dropdown-item",{nativeOn:{click:function(s){return t.changeStatus(t.status.id,!0,t.status.visibility)}}},[t._v("\n                "+t._s(t.$t("reports.addSensitive"))+"\n              ")]),t._v(" "),t.status.sensitive?e("el-dropdown-item",{nativeOn:{click:function(s){return t.changeStatus(t.status.id,!1,t.status.visibility)}}},[t._v("\n                "+t._s(t.$t("reports.removeSensitive"))+"\n              ")]):t._e(),t._v(" "),"public"!==t.status.visibility?e("el-dropdown-item",{nativeOn:{click:function(s){return t.changeStatus(t.status.id,t.status.sensitive,"public")}}},[t._v("\n                "+t._s(t.$t("reports.public"))+"\n              ")]):t._e(),t._v(" "),"private"!==t.status.visibility?e("el-dropdown-item",{nativeOn:{click:function(s){return t.changeStatus(t.status.id,t.status.sensitive,"private")}}},[t._v("\n                "+t._s(t.$t("reports.private"))+"\n              ")]):t._e(),t._v(" "),"unlisted"!==t.status.visibility?e("el-dropdown-item",{nativeOn:{click:function(s){return t.changeStatus(t.status.id,t.status.sensitive,"unlisted")}}},[t._v("\n                "+t._s(t.$t("reports.unlisted"))+"\n              ")]):t._e(),t._v(" "),e("el-dropdown-item",{nativeOn:{click:function(s){return t.deleteStatus(t.status.id)}}},[t._v("\n                "+t._s(t.$t("reports.deleteStatus"))+"\n              ")])],1)],1)],1)])]),t._v(" "),e("div",{staticClass:"status-body"},[t.status.spoiler_text?e("div",[e("strong",[t._v(t._s(t.status.spoiler_text))]),t._v(" "),t.showHiddenStatus?t._e():e("el-button",{staticClass:"show-more-button",attrs:{size:"mini"},on:{click:function(s){t.showHiddenStatus=!0}}},[t._v("Show more")]),t._v(" "),t.showHiddenStatus?e("el-button",{staticClass:"show-more-button",attrs:{size:"mini"},on:{click:function(s){t.showHiddenStatus=!1}}},[t._v("Show less")]):t._e(),t._v(" "),t.showHiddenStatus?e("div",[e("span",{staticClass:"status-content",domProps:{innerHTML:t._s(t.status.content)}}),t._v(" "),t.status.poll?e("div",{staticClass:"poll"},[e("ul",t._l(t.status.poll.options,function(s,a){return e("li",{key:a},[t._v("\n                "+t._s(s.title)+"\n                "),e("el-progress",{attrs:{percentage:t.optionPercent(t.status.poll,s)}})],1)}),0)]):t._e(),t._v(" "),t._l(t.status.media_attachments,function(t,s){return e("div",{key:s,staticClass:"image"},[e("img",{attrs:{src:t.preview_url}})])})],2):t._e()],1):t._e(),t._v(" "),t.status.spoiler_text?t._e():e("div",[e("span",{staticClass:"status-content",domProps:{innerHTML:t._s(t.status.content)}}),t._v(" "),t.status.poll?e("div",{staticClass:"poll"},[e("ul",t._l(t.status.poll.options,function(s,a){return e("li",{key:a},[t._v("\n              "+t._s(s.title)+"\n              "),e("el-progress",{attrs:{percentage:t.optionPercent(t.status.poll,s)}})],1)}),0)]):t._e(),t._v(" "),t._l(t.status.media_attachments,function(t,s){return e("div",{key:s,staticClass:"image"},[e("img",{attrs:{src:t.preview_url}})])})],2),t._v(" "),e("a",{staticClass:"account",attrs:{href:t.status.url,target:"_blank"}},[t._v("\n        "+t._s(t.parseTimestamp(t.status.created_at))+"\n      ")])])])],1)},[],!1,null,null,null);o.options.__file="index.vue";s.a=o.exports}}]);
//# sourceMappingURL=chunk-ce58.20269345.js.map