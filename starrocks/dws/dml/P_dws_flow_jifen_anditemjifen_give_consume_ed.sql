----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_jifen_anditemjifen_give_consume_ed
-- workflow_version : 7
-- create_user      : zhugl
-- task_name        : tbl_dws_flow_jifen_anditemjifen_give_consume_ed
-- task_version     : 7
-- update_time      : 2023-12-15 16:28:06
-- sql_path         : \starrocks\tbl_dws_flow_jifen_anditemjifen_give_consume_ed\tbl_dws_flow_jifen_anditemjifen_give_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete  from dws.dws_flow_jifen_anditemjifen_give_consume_ed   where dt='${bf_1_dt}';

-- SQL语句
insert into dws.dws_flow_jifen_anditemjifen_give_consume_ed
select
a.dt,
a.product_id,
a.user_id,
a.taskname,
b.corever,
b.mt,
b.app_ver,
a.give_points_total, -- 积分发放
a.consume_points_total, -- 积分消耗
a.give_coupon_total,
a.expire_coupon_total,
a.give_item_points_total,
a.expire_item_points_total,
case when b.ads_type !='' and b.ads_quality =0 then '1'
when b.is_has_charge=0 and b.is_negative_user =1 then '2'
when b.is_has_charge=1 and b.is_negative_user = 1 then '3'
else '4' end  as usertype,
now()
from (
select
a.dt,
a.product_id,
a.user_id,
a.taskname,
sum(case when op = 1 then num else 0 end) as give_points_total, -- 积分发放
sum(case when op = 2 then num else 0 end) as consume_points_total, -- 积分消耗
sum(case when op = 1 then send_num else 0 end) as give_coupon_total,
sum(case when op = 2 then send_num else 0 end) as expire_coupon_total,
sum(case when op = 1 then item_num else 0 end) as give_item_points_total,
sum(case when op = 2 then item_num else 0 end) as expire_item_points_total
from
(select dt, product_id, user_id, op,num,0 send_num,0 item_num,'' taskname from dwd.dwd_grant_readerlog_jifenmonthlog_view a where dt >='${bf_1_dt}' and  op in (1,2)
union all
select  dt, product_id, user_id, op_type,0,send_num,0 item_num,'' taskname from dwd.dwd_grant_user_giftlog where dt >='${bf_1_dt}' and  gift_type = 0
and source_key not in ('VipUpgradeSend','BonusCardName','BonusCardPlusName','BonusCardPlusPlus_Name','GiftMsg3','DelAdChargeResource','ChargeReturnResource','EDM_3rd_party_title','AppUserMonthCard','OnePurchaseSource','TimelimitChargeResource','Reading_event','Special gift','FirstBindEmail','特別禮券','Coupons pour vous','Bônus especial','MemberMonthGiftTitle')
union all
select dt, product_id, user_id, op,0,0,num ,
case when source_key = 'PointsCenterWatchVideoTaskAward' then '任务激励视频'
when source_key = 'ExtraWatchVideoTaskAward' then '看额外激励视频'
when source_key = 'PopupWindowWatchVideoTaskAward' then '弹窗激励视频'
when source_key = 'BookshelfWatchAdTaskAward' then '书架激励视频'
when source_key = 'WelfareWatchVideoAward' then '福利中心激励视频'
when source_key = 'BounsWatchAdGetPointSource' then '签到积分视频'
when source_key = 'JiFenLottery' then '积分抽奖'
when source_key = 'JiFenRankAward' then '积分排行榜'
when source_key like 'DigTreasureLottery%' then '挖宝人积分抽奖'
when source_key = 'PointBoxTaskAward' or concat(source,source_key) in ('Hadiah Peti PoinTaskAward','Hadiah tugas-Beli babTaskAward') then '宝箱'
when source_key  in ('MealTask','eatting_breakfast','eatting_dinner','eatting_lunch') then '吃饭'
when source_key = 'invite' then '邀请好友'
when source_key = 'CoinExchange' then '商城'
when source_key = 'OldJiFenSource' then '积分迁移'
when source_key = 'SignRewadMsg' then '签到积分'
when concat(source,source_key) in ('Task rewards-Daily ReadingTaskAward','Récompenses de tâche - LectureTaskAward','Hadiah tugas-Membaca HarianTaskAward','任務獎勵-每日閱讀TaskAward','Recompensas de tarefas- Ler hojeTaskAward','รางวัลภารกิจ - อ่านรายวันTaskAward','Призы за задания-Ежедневное чтениеTaskAward','Task rewards-Daily ReadingTaskAward','Recompensas de tarefas- Ler livrosTaskAward','ミッションボーナス- 本を読むTaskAward','Task rewards-Daily Reading','Récompenses de tâche - Lecture','Hadiah tugas-Membaca Harian','任務獎勵-每日閱讀','Recompensas de tarefas- Ler hoje','รางวัลภารกิจ - อ่านรายวัน','Призы за задания-Ежедневное чтение','ミッションボーナス- 本を読む') then '阅读'
when concat(source,source_key) in ('Task rewards-Reading BooksTaskAward','Premios de tareas -Leer librosTaskAward','Premios de tareas -Leer hoyTaskAward','Récompenses de tâche - DécouverteTaskAward','Récompenses de tâche - Découvrir les livresTaskAward','Hadiah tugas-Membaca BukuTaskAward','任務獎勵-閱讀書籍TaskAward','Recompensas de tarefas- Ler livrosTaskAward','รางวัลภารกิจ - อ่านหนังสือTaskAward','Призы за задания-ЧтениеTaskAward','Task rewards-Reading Books','Premios de tareas -Leer libros','Premios de tareas -Leer hoy','Récompenses de tâche - Découverte','Hadiah tugas-Membaca Buku','任務獎勵-閱讀書籍','Recompensas de tarefas- Ler livros','รางวัลภารกิจ - อ่านหนังสือ','Призы за задания-Чтение') then '定向阅读'
when concat(source,source_key) in ('Task rewards-Play gamesTaskAward','Task rewards-Play GamesTaskAward','Premios de tareas -Jugar juegosTaskAward','Recompensas de tarefas- Participar dos jogosTaskAward','Recompensas de tarefas- Jogar jogosTaskAward','Récompenses de tâche - Jouer aux jeuxTaskAward','任務獎勵-玩遊戲TaskAward','Призы за задания-Играть в игрыTaskAward','Premios de tareas -Obtendrá Puntos por jugar juegosTaskAward','Hadiah tugas-Main GameTaskAward','รางวัลภารกิจ - เล่นเกมTaskAward','ミッションボーナス- ゲームを遊ぶTaskAward') then '玩游戏'
when concat(source,source_key) in ('Task rewards-Purchase ChaptersTaskAward','Recompensas de tarefas- Desbloquear CapítulosTaskAward','Premios de tareas -Comprar capítulosTaskAward','Récompenses de tâche - AchatTaskAward','Hadiah tugas-Beli BabTaskAward','รางวัลภารกิจ - ซื้อบทTaskAward','รางวัลภารกิจ - บทที่ซื้อTaskAward','任務獎勵-購買章節TaskAward','Призы за задания-Покупка ГлавTaskAward','Task rewards-Purchase chaptersTaskAward','Recompensas de tarefas- Comprar capítulosTaskAward','Récompenses de tâche - Acheter des chapitresTaskAward','Призы за задания-Главы каждый деньTaskAward','任務獎勵-每日購買章節TaskAward') then '购买章节'
when concat(source,source_key) in ('Task rewards-Visit the StoreTaskAward','Task rewards-Visit the Store for 30sTaskAward','Premios de tareas -Visitar la TiendaTaskAward','Premios de tareas -Visitar la Tienda por 30sTaskAward','Premios de tareas -Ver la Tienda porTaskAward','Premios de tareas -Ver la Tienda por 30 segundosTaskAward','Recompensas de tarefas- Visitar a LojaTaskAward','Recompensas de tarefas- Visitar a Loja por 30 segundosTaskAward','Premios de tareas -Visitar la TiendaTaskAward','Premios de tareas -Visitar la Tienda durante 30 segundosTaskAward','รางวัลภารกิจ - เยือนร้านค้าTaskAward','Récompenses de tâche - Visiter la FoireTaskAward','Hadiah tugas-Kunjungi Mal TaskAward','Призы за задания-Просмотр МагазинаTaskAward','รางวัลภารกิจ - เยือนร้าน 30 วินาทีTaskAward','任務獎勵-瀏覽商城TaskAward','任務獎勵-瀏覽商城30秒TaskAward','Призы за задания-Будьте в магазине 30 сек.TaskAward') then '浏览商城'
when concat(source,source_key) in ('Task rewards-Visit Bonus page for 30sTaskAward','Task rewards-Visit Bonus page for 30sTaskAward','Premios de tareas -Visitar la página de Bonus por 30sTaskAward','Recompensas de tarefas- Visitar a página Bônus por 30sTaskAward','Récompenses de tâche - Parcourir la page Bonus pendant 30sTaskAward','Récompenses de tâche - Visiter la Foire pendant 30 secondesTaskAward','Hadiah tugas-Jelajahi Bonus 30 detikTaskAward','Hadiah tugas-Kunjungi Toko untuk 30 detikTaskAward','Призы за задания-Просмотр Бонуса: 30 сек.TaskAward','รางวัลภารกิจ - ชมศูนย์โบนัส 30 นาทีTaskAward','任務獎勵-瀏覽福利中心30秒TaskAward') then '浏览福利中心'
when concat(source,source_key) in ('Task rewards-CommentTaskAward','Recompensas de tarefas- Deixar ComentárioTaskAward','Premios de tareas -Dejar comentariosTaskAward','Hadiah tugas-KomentarTaskAward','รางวัลภารกิจ - แสดงความคิดเห็นTaskAward','Récompenses de tâche - CommentaireTaskAward','任務獎勵-發表評論TaskAward','Призы за задания-КомментарииTaskAward','Premios de tareas -Dejar un comentarioTaskAward','Recompensas de tarefas- Deixar um comentárioTaskAward','Task rewards-Write a commentTaskAward','รางวัลภารกิจ - เขียน 1 ความคิดเห็นTaskAward','Récompenses de tâche - Laisser un commentaireTaskAward','Призы за задания-Напишите 1 отзывTaskAward','Hadiah tugas-Tulis 1 komentarTaskAward','任務獎勵-寫1條評論TaskAward') then '评论'
when concat(source,source_key) in ('Premios de tareas -Vincular E-mailTaskAward','Task rewards-EmailTaskAward','Recompensas de tarefas- Vincular E-mailTaskAward','Призы за задания-EmailTaskAward','Récompenses de tâche - E-mailTaskAward','任務獎勵-綁定郵箱TaskAward','รางวัลภารกิจ - อีเมลTaskAward','Hadiah tugas-EmailTaskAward','ミッションボーナス- メールアドレスTaskAward') then '绑定邮箱'
when concat(source,source_key) in ('Task rewards-RechargeTaskAward','Recompensas de tarefas- RecarregarTaskAward','Premios de tareas -Recargar MonedasTaskAward','Récompenses de tâche - RechargeTaskAward','รางวัลภารกิจ - เติมเหรียญTaskAward','任務獎勵-充值TaskAward','Призы за задания-ПополнитьTaskAward','Hadiah tugas-Isi ulangTaskAward','Récompenses de tâche - PartageTaskAward') then '充值'
when concat(source,source_key) in ('Premios de tareas -Dar \"Me gusta\" a 3 comentariosTaskAward','Recompensas de tarefas- Curtir 3 comentáriosTaskAward','Task rewards-Like 3 comment(s)TaskAward','Premios de tareas -Dar \"Me gusta\"TaskAward','Task rewards-Like commentsTaskAward','Recompensas de tarefas- Curtir comentáriosTaskAward','Premios de tareas -Dar \"Me gusta\" a los comentariosTaskAward','Призы за задания-Лайкните 3 отзыв(ов)TaskAward','Призы за задания-Лайкните 3 отзыв(ов)TaskAward','Hadiah tugas-Menyukai 3 komentarTaskAward','Hadiah tugas-Sukai komentarTaskAward','รางวัลภารกิจ - กดไลค์ความคิดเห็นTaskAward','任務獎勵-點贊評論TaskAward','รางวัลภารกิจ - กดไลค์ 3 ความคิดเห็นTaskAward','任務獎勵-點贊3條評論TaskAward','Призы за задания-Лайкнуть ОтзывTaskAward') then '点赞'
when concat(source,source_key) in ('Task rewards-Tip A BookTaskAward','Recompensas de tarefas- Dar gorjeta ao livroTaskAward','Récompenses de tâche - PourboireTaskAward','Premios de tareas -Dar propinasTaskAward','รางวัลภารกิจ - สนับสนุนTaskAward','任務獎勵-打賞書籍TaskAward','Hadiah tugas-Tip Sebuah BukuTaskAward','Призы за задания-Дать чаевые книгеTaskAward') then '打赏书籍'
when concat(source,source_key) in ('Task rewards-ShareTaskAward','Recompensas de tarefas- CompartirTaskAward','Premios de tareas -Compartir librosTaskAward','Hadiah tugas-BagikanTaskAward','任務獎勵-分享TaskAward','รางวัลภารกิจ - แชร์TaskAward','Призы за задания-Отпр.TaskAward') then '分享'
when concat(source,source_key) in ('Task rewards-AccountTaskAward','Premios de tareas -Vincular cuentasTaskAward','Recompensas de tarefas- Vincular ContaTaskAward','Récompenses de tâche - CompteTaskAward','任務獎勵-賬號綁定 TaskAward','รางวัลภารกิจ - บัญชีTaskAward','Призы за задания-АккаунтTaskAward','Hadiah tugas-AkunTaskAward') then '第三方账号绑定'
when concat(source,source_key) in ('Task rewards-Complete Personal DetailsTaskAward','Recompensas de tarefas- Completar InformaçõesTaskAward','Premios de tareas -Completar datos de usuarioTaskAward','Récompenses de tâche - ProfilTaskAward','รางวัลภารกิจ - กรอกรายละเอียดข้อมูลส่วนบุคคลTaskAward','Призы за задания-Заполните личные данныеTaskAward','任務獎勵-完善個人信息TaskAward','Hadiah tugas-Lengkapi Rincian PribadiTaskAward') then '填写个人信息'
when concat(source,source_key) in ('Task rewards-Watch VideoTaskAward','任務獎勵-觀看激勵視頻 TaskAward','Premios de tareas -Ver vídeosTaskAward','旧版看激励视频TaskAward','Récompenses de tâche - Regardez la vidéo de démoTaskAward','Recompensas de tarefas- Assista o vídeo de incentivoTaskAward','Призы за задания-Посмотреть бонусное видеоTaskAward','觀看激勵視頻 WatchIncentiveVideo','Watch incentive videoWatchIncentiveVideo','Vea el vídeo.WatchIncentiveVideo','Regardez la vidéo de démoWatchIncentiveVideo','Посмотреть бонусное видеоWatchIncentiveVideo') then '旧版激励视频'
else '未知'
end task_name
from dwd.dwd_grant_jifenitemmonthlog   where dt >='${bf_1_dt}'
)a
group by 1,2,3,4)a
left  join dim.dim_user_all_info b on a.user_id = b.user_id and a.product_id = b.product_id;
