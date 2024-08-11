-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 11, 2024 at 03:25 PM
-- Server version: 10.1.40-MariaDB
-- PHP Version: 7.3.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tsstock`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_LG_Record` (`p_msg` VARCHAR(300), `p_prcs` VARCHAR(50), `p_prcstg` VARCHAR(50), `p_objt` VARCHAR(50), `p_uid` INT, `p_unm` VARCHAR(50))  BEGIN

declare v_id int unsigned;

select ifnull(max(id),0) + 1 into v_id from t_log_recorded;

insert into t_log_recorded
(id,msg,prcs,prcstg,objt,uid,unm,dt)
values(
v_id,
p_msg,
p_prcs,
p_prcstg,
p_objt,
p_uid,
p_unm,
sysdate()
);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_LG_Record_CL` (`p_ss` INT, `p_id` INT, `p_msg` VARCHAR(300), `p_prcs` VARCHAR(50), `p_prcstg` VARCHAR(50), `p_objt` VARCHAR(50), `p_uid` INT, `p_unm` VARCHAR(50))  BEGIN

declare v_id int unsigned;

set v_id = p_id;

call PC_LG_Record(v_id,p_msg,p_prcs,p_prcstg,p_objt,p_uid,p_unm);

if(p_ss=1)then
  select v_id as id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Company` (`p_proc` VARCHAR(20), INOUT `p_id` INT, `p_cmpcd` VARCHAR(10), `p_company` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int;
declare v_prcs varchar(50) default '';

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),0) + 1 into p_id from t_stock_company;

    insert into t_stock_company
    (id,cmpcd,company,sts,cbid,cby,cdt)
    values(
    p_id,
    p_cmpcd,
    p_company,
    p_sts,
    p_cbid,
    p_cby,
    p_cdt
    );

    set v_prcs = 'INSERTED';

  else

    update t_stock_company
    set cmpcd = p_cmpcd,company = p_company where id = p_id;

    set v_prcs = 'UPDATED';

  end if;

end if;

if(p_proc='Delete') then

  select id into v_id from t_stock_company where id = p_id and sts = 'ACTIVE';

  if(v_id is null) then

    set p_id = 0;

  else

    update t_stock_company set sts = 'DELETED'
    where id = p_id;

    set v_prcs = 'DELETED';

  end if;

end if;


if(v_prcs!='') then
  call PC_LG_Record(p_id,v_prcs,'SUCCESS','T_STOCK_COMPANY',p_cbid,p_cby);
end if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Company_CL` (`p_ss` INT, `p_proc` VARCHAR(20), `p_id` INT, `p_cmpcd` VARCHAR(10), `p_company` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int default null;

set v_id = p_id;

call PC_MT_Company(p_proc,v_id,p_cmpcd,p_company,p_sts
,p_cbid,p_cby,p_cdt);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Department` (`p_proc` VARCHAR(20), INOUT `p_id` INT, `p_cmpid` INT, `p_cmpcd` VARCHAR(10), `p_plntid` INT, `p_plntcd` VARCHAR(10), `p_deptcd` VARCHAR(10), `p_dept` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int;

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),0) + 1 into p_id from t_stock_department;

    insert into t_stock_department
    (id,cmpid,cmpcd,plntid,plntcd,deptcd,dept,sts,cbid,cby,cdt)
    values(
    p_id,
    p_cmpid,
    p_cmpcd,
    p_plntid,
    p_plntcd,
    p_deptcd,
    p_dept,
    p_sts,
    p_cbid,
    p_cby,
    p_cdt
    );

  else

    update t_stock_department
    set
    cmpid=p_cmpid,cmpcd = p_cmpcd,
    plntid = p_plntid,plntcd = p_plntcd,
    deptcd = p_deptcd,dept = p_dept where id = p_id;

  end if;

end if;

if(p_proc='Delete') then

  select id into v_id from t_stock_company where id = p_id;

  if(v_id is null) then

    set p_id = 0;

  else

    update t_stock_company set sts = 'Deleted'
    where id = p_id;

  end if;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Location` (`p_proc` VARCHAR(20), INOUT `p_id` INT, `p_loc` VARCHAR(50), `p_cmpid` INT, `p_cmpcd` VARCHAR(10), `p_plntid` INT, `p_plntcd` VARCHAR(10), `p_deptid` INT, `p_deptcd` VARCHAR(10), `p_dept` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int;
declare v_prcs varchar(50) default '';

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),0) + 1 into p_id from t_stock_location;

    insert into t_stock_location
    (id,loc,cmpid,cmpcd,plntid,plntcd,deptid,deptcd,dept,sts,cbid,cby,cdt)
    values(
    p_id,
    p_loc,
    p_cmpid,
    p_cmpcd,
    p_plntid,
    p_plntcd,
    p_deptid,
    p_deptcd,
    p_dept,
    p_sts,
    p_cbid,
    p_cby,
    p_cdt
    );

    set v_prcs = 'INSERTED';

  else

    update t_stock_location
    set
    cmpid=p_cmpid,cmpcd = p_cmpcd
    ,plntcd=p_plntcd,plntid = p_plntid
    ,deptid = p_deptid,deptcd=deptcd,loc=p_loc
     where id = p_id;

    set v_prcs = 'UPDATED';

  end if;

end if;

if(p_proc='Delete') then

  select id into v_id from t_stock_location where id = p_id and sts = 'ACTIVE';

  if(v_id is null) then

    set p_id = 0;

  else

    update t_stock_location set sts = 'DELETED'
    where id = p_id;

    set v_prcs = 'DELETED';

  end if;

end if;


if(v_prcs!='') then
  call PC_LG_Record(p_id,v_prcs,'SUCCESS','T_STOCK_PLANT',p_cbid,p_cby);
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Plant` (`p_proc` VARCHAR(20), INOUT `p_id` INT, `p_cmpid` INT, `p_cmpcd` VARCHAR(10), `p_plntcd` VARCHAR(10), `p_plant` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int;
declare v_prcs varchar(50) default '';

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),0) + 1 into p_id from t_stock_plant;

    insert into t_stock_plant
    (id,cmpid,cmpcd,plntcd,plant,sts,cbid,cby,cdt)
    values(
    p_id,
    p_cmpid,
    p_cmpcd,
    p_plntcd,
    p_plant,
    p_sts,
    p_cbid,
    p_cby,
    p_cdt
    );

    set v_prcs = 'INSERTED';

  else

    update t_stock_plant
    set cmpid=p_cmpid,cmpcd = p_cmpcd,plntcd=p_plntcd,plant = p_plant where id = p_id;

    set v_prcs = 'UPDATED';

  end if;

end if;

if(p_proc='Delete') then

  select id into v_id from t_stock_company where id = p_id and sts = 'ACTIVE';

  if(v_id is null) then

    set p_id = 0;

  else

    update t_stock_company set sts = 'DELETED'
    where id = p_id;

    set v_prcs = 'DELETED';

  end if;

end if;


if(v_prcs!='') then
  call PC_LG_Record(p_id,v_prcs,'SUCCESS','T_STOCK_PLANT',p_cbid,p_cby);
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PC_MT_Plant_CL` (`p_ss` INT, `p_proc` VARCHAR(20), `p_id` INT, `p_cmpid` INT, `p_cmpcd` VARCHAR(10), `p_plntcd` VARCHAR(10), `p_plant` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int;

set v_id = p_id;

call PC_MT_Plant(p_proc,v_id,p_cmpid,p_cmpcd,p_plntcd,p_plant,p_sts
,p_cbid,p_cby,p_cdt);

if(p_ss=1) then
select v_id as id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_Mast_SubLocation` (`p_proc` VARCHAR(20), INOUT `p_id` INT, `p_sloc` VARCHAR(50), `p_lcid` INT, `p_location` VARCHAR(50))  BEGIN

declare v_id int;

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),1) + 1 into p_id from t_stock_sub_loc;

    insert into t_stock_sub_loc
    (id,sloc,lcid,loc)
    values(
    p_id,
    p_sloc,
    p_lcid,
    p_location);

  else

    update t_stock_sub_loc
    set sloc = p_sloc where id = p_id;

  end if;

end if;

if(p_proc='Delete') then

  select id into v_id from t_stock_sub_loc where id = p_id;

  if(v_id is null) then

    set p_id = 0;

  else

    delete from t_stock_item
    where id = p_id;

  end if;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_Mast_SubLocation_Call` (`p_proc` VARCHAR(20), `p_ss` INT, `p_id` INT, `p_sloc` VARCHAR(40), `p_lcid` INT, `p_loc` VARCHAR(50))  BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_Mast_SubLocation(p_proc,v_id,p_sloc,p_lcid,p_loc);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockAdd` (`p_skid` DOUBLE, `v_bprocess` VARCHAR(30), `v_process` VARCHAR(30), `v_loc` VARCHAR(40), `v_sloc` VARCHAR(40), `v_ssloc` VARCHAR(40), `v_itid` INT, `v_mtcd` VARCHAR(20), `v_material` VARCHAR(200), `v_make` VARCHAR(40), `v_uom` VARCHAR(40), `v_critical` VARCHAR(40), `v_issueto` VARCHAR(100), `v_takenby` VARCHAR(100), `v_toloc` VARCHAR(40), `v_dt` DATETIME, `p_cby` VARCHAR(40), `p_spid` INT, `p_sl` INT, `v_qty` INT, `p_rem` VARCHAR(200))  BEGIN

  declare v_skid double default null;
  declare v_sl int;
  declare v_id double;

  select ifnull(max(id),700000) + 1 into v_id from t_stock;

  call PROC_StockSerial(v_skid,v_sl,v_itid,v_material,v_loc,v_sloc,v_ssloc,v_make,v_critical);

  insert into t_stock(skid,sl,id,bprocess,process,loc,sloc,ssloc,make,itid,mtcd,material,qty,dt,cdt,cby
    ,critical,spid,spsl,uom,sts,tloc,issueto,takenby,rem)
    values(v_skid,v_sl,v_id,v_bprocess,v_process,v_loc,v_sloc,v_ssloc,v_make,v_itid,v_mtcd,v_material,v_qty
    ,v_dt,sysdate(),p_cby,v_critical,p_spid,p_sl,v_uom,'A',v_toloc,v_issueto,v_takenby,p_rem);

  update t_stock_process_line set skid = v_skid where spid = p_spid and sl = p_sl and skid is null;

  call PROC_StockQuanityUpdate(v_skid);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockAdjustQuantity` (`p_skid` DOUBLE, `p_qty` INT, `p_loc` VARCHAR(40), `p_cby` VARCHAR(40))  BEGIN

  declare v_skid int default null;

  declare v_itid int;
  declare v_mtcd varchar(20);
  declare v_material varchar(200);
  declare v_make,v_loc,v_sloc,v_ssloc,v_uom varchar(40);
  declare v_critical varchar(3);

  select distinct itid,mtcd,material,loc,sloc,ssloc,make,critical,uom
      into
      v_itid,v_mtcd,v_material,v_loc,v_sloc,v_ssloc,v_make,v_critical,v_uom
      from t_stock where skid = p_skid and sts = 'A';

  call PROC_StockProcessAdd(v_skid,'StockAdjustment',NULL,p_loc,NULL,NULL,NULL,NULL,sysdate(),p_cby);
  call PROC_StockProcessAdd_Line(v_skid,1,sysdate(),'StockAdjustment','SA',p_loc,v_sloc,v_ssloc,
  v_make,v_uom,v_itid,v_mtcd,v_material,v_critical,0,NULL,NULL,NULL,NULL,NULL,NULL,p_skid);
 call PROC_StockSetup(v_skid);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockDelete` (`p_skid` INT)  BEGIN

declare v_itid int default null;
declare v_scnt int default 0;

select max(itid) into v_itid from t_stock where skid = p_skid;

if (v_itid is not null) then

  update t_stock set sts = 'D' where skid = p_skid;

  update v_stock_base set sts = 'D' where skid = p_skid;

  select count(itid) into v_scnt from t_stock where itid = v_itid and sts = 'A';

  if(v_scnt=0) then

    update t_stock_item set sts = 'D' where id = v_itid;

  end if;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockEmployeeIssue` (`p_spno` VARCHAR(30), `p_ctnm` VARCHAR(30), `p_lcid` INT, `p_loc` VARCHAR(40))  BEGIN

  declare v_id int default null;

  select id into v_id from t_stock_out_emp_issue
  where spno = p_spno and ctnm = p_ctnm and lcid = p_lcid and loc = p_loc;

  if(v_id is null) then

    select ifnull(max(id),0) + 1 into v_id from t_stock_out_emp_issue;

    insert into t_stock_out_emp_issue(id,spno,ctnm,lcid,loc)
    values(
    v_id,
    p_spno,
    p_ctnm,
    p_lcid,
    p_loc);

  end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcel` (`p_id` INT)  BEGIN

  declare i,v_partid int;

  declare v_spid,v_sl int;

  declare v_loc,v_cby,v_process,v_sts varchar(50);

  declare v_dt datetime;

  declare v_material varchar(200) default null;

  declare v_qty,v_exl_skid,v_idx int default null;

  declare ch_done int default 0;

  declare Component_CR cursor for select sl from t_stock_excel_line where seid = p_id order by sl;

  declare continue handler for not found set ch_done = 1;

  select dt,loc,cby,process,sts into v_dt,v_loc,v_cby,v_process,v_sts from t_stock_excel where id = p_id;

  if (v_sts='New') then

    call PROC_StockProcessAdd(v_spid,v_process, NULL, v_loc,NULL,NULL,NULL,NULL,v_dt,v_cby);

    OPEN Component_CR;

      Component:LOOP

        FETCH Component_CR INTO v_sl;

        IF ch_done <> 1 THEN

           call PROC_StockExcel_Line(p_id,v_spid,v_sl,v_process,v_cby);

        ELSE

          LEAVE Component;

        END IF;

        set i = i + 1;

      END LOOP Component;

    CLOSE Component_CR;


    if(v_process!='StockTransferExcel') then

      call PROC_StockSetup(v_spid);

      update t_stock_excel set sts = 'Released' where id = p_id;

    end if;

  end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcelAdd` (INOUT `p_id` INT, `p_process` VARCHAR(20), `p_dt` DATE, `p_lcid` INT, `p_loc` VARCHAR(50), `p_rem` VARCHAR(200), `p_sts` VARCHAR(30), `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

if(p_id is null) then

  select ifnull(max(id),50000) + 1 into p_id from t_stock_excel;

  insert into t_stock_excel(id,process,dt,lcid,loc,rem,sts,cby,cdt) values(
  p_id,
  p_process,
  p_dt,
  p_lcid,
  p_loc,
  p_rem,
  p_sts,
  p_cby,
  p_cdt);

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcelAdd_Call` (`p_ss` INT, `p_id` INT, `p_process` VARCHAR(20), `p_dt` DATE, `p_lcid` INT, `p_loc` VARCHAR(50), `p_rem` VARCHAR(200), `p_sts` VARCHAR(30), `p_cby` VARCHAR(30), `p_cdt` DATETIME)  BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_StockExcelAdd(v_id,p_process,p_dt,p_lcid,p_loc
, p_rem,p_sts,p_cby,p_cdt);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcel_Line` (`p_seid` INT, `p_spid` INT, `p_sl` INT, `p_process` VARCHAR(45), `p_cby` VARCHAR(50))  BEGIN

declare v_lcid int default null;

declare v_exists,v_umcf int default null;
declare v_rem,v_sprem varchar(100) default '';
declare v_dt varchar(15);
declare v_itid int;
declare v_mtcd,v_code varchar(20);
declare v_material varchar(200);
declare v_make,v_loc,v_sloc,v_ssloc,v_toloc,v_tosloc,v_tossloc,v_uom varchar(40);
declare v_qty,v_wlvl,v_rlvl int;
declare v_critical varchar(3);
declare v_sublocall varchar(500) default '';
declare v_skid double;
declare v_scsts varchar(1) default 'N';

   select rem into v_rem from t_stock_excel_line where seid = p_seid and sl = p_sl;

   if(v_rem is null) then

    select FN_StockIDFromExcelID(p_seid,p_sl) into v_skid from t_stock_excel_line where seid = p_seid and sl = p_sl;

    if(v_skid is not null) then

      select distinct itid,mtcd,material,loc,sloc,ssloc,make,critical,uom
      into
      v_itid,v_mtcd,v_material,v_loc,v_sloc,v_ssloc,v_make,v_critical,v_uom
      from t_stock where skid = v_skid;

      select distinct dt,qty,toloc,tosloc,tossloc
      into
      v_dt,v_qty,v_toloc,v_tosloc,v_tossloc
      from t_stock_excel_line where seid = p_seid and sl = p_sl;

      set v_rem = FN_StockExcelValidationCheck(v_dt,p_process,v_mtcd,v_loc,v_sloc,v_ssloc,v_qty,
      v_toloc,v_tosloc,v_tossloc,v_skid);

      if(v_rem='') then

        select 1 into v_exists from t_stock_process_line
        where spid = p_spid and itid = v_itid and loc = v_loc
        and sloc = v_sloc and ssloc = v_ssloc and make = v_make and critical = v_critical;

        if v_exists is null then

        select code into v_code from t_stock_process_code where process = p_process;

          if (p_process='InternalMovementExcel') then

            set v_sublocall = concat(v_tosloc,':',v_tossloc,':',v_qty);

          end if; -- if (p_process='InternalMovementExcel') then

          call PROC_StockProcessAdd_Line(p_spid,p_sl,str_to_date(v_dt, '%d.%m.%Y'), p_process, v_code, v_loc
          ,v_sloc,v_ssloc,v_make,v_uom,v_itid,v_mtcd,v_material,v_critical,v_qty,NULL,NULL,NULL
          , v_toloc, v_sublocall,NULL,v_skid);

          set v_rem =  concat(v_rem,p_process,' : Done with Quantity ( ',v_qty, ' ) Stock ID : ',v_skid);

          set v_scsts = 'Y';

        else -- if v_exists is null then

          set v_rem =  concat(v_rem,'Duplicate Entry Found');

        end if; -- if v_exists is null then

      end if; -- if(v_rem='') then

    else -- if(v_skid is not null) then


      select dt,loc,sloc,ssloc,make,mtcd,material,qty,critical,toloc,tosloc,tossloc,uom,wlvl,rlvl
      into
      v_dt,v_loc,v_sloc,v_ssloc,v_make,v_mtcd,v_material,v_qty,
      v_critical,v_toloc,v_tosloc,v_tossloc,v_uom,v_wlvl,v_rlvl
      from t_stock_excel_line where seid = p_seid and sl = p_sl;

      set v_rem = FN_StockExcelValidationCheck(v_dt,p_process,v_mtcd,v_loc,v_sloc,v_ssloc,v_qty,
      v_toloc,v_tosloc,v_tossloc,v_skid);

      if(v_rem='') then

          if(trim(v_material)!='' and trim(v_critical)!='' and trim(v_uom)!='') then

            select max(id) into v_itid from t_stock_item where
            trim(upper(mtcd)) = upper(trim(v_mtcd)) and
            upper(trim(material)) = upper(trim(v_material))
            and loc = v_loc and sts = 'A';

            if (v_itid is null) then

              call PROC_StockItemAdd_Small
              (v_itid,v_mtcd,v_material,v_lcid,v_loc,v_uom,v_critical,str_to_date(v_dt, '%d.%m.%Y'),p_cby,0,v_wlvl,v_rlvl);

              set v_rem = concat('UMC Created : (',v_itid,') : ');

            end if; -- if (v_itid is null) then

            select 1 into v_exists from t_stock_process_line
            where spid = p_spid and itid = v_itid and loc = v_loc
            and sloc = v_sloc and ssloc = v_ssloc and make = v_make and critical = v_critical;

            if v_exists is null then

              select code into v_code from t_stock_process_code where process = p_process;

              if (p_process='InternalMovementExcel') then

                set v_sublocall = concat(v_tosloc,':',v_tossloc,':',v_qty);

              end if; -- if (p_process='InternalMovementExcel') then

              call PROC_StockProcessAdd_Line(p_spid,p_sl,str_to_date(v_dt, '%d.%m.%Y'), p_process, v_code, v_loc
              ,v_sloc,v_ssloc,v_make,v_uom,v_itid,v_mtcd,v_material,v_critical,v_qty,NULL,NULL,NULL
              , v_toloc, v_sublocall,NULL,v_skid);

              set v_rem =  concat(v_rem,p_process,' : Done with Quantity ( ',v_qty, ' )');

              set v_scsts = 'Y';

            else -- if v_exists is null then

            set v_rem =  concat(v_rem,'Duplicate Entry Found');

          end if; -- if v_exists is null then

      else -- if(trim(v_material)!='' and trim(v_critical)!='' and trim(v_uom)!='') then

          set v_rem = concat('Invalid details please provide (Material,UOM and Critical) : ');

      end if; -- if(trim(v_material)!='' and trim(v_critical)!='' and trim(v_uom)!='') then


      end if; -- if(v_rem='') then

    end if; -- if(v_skid is not null) then

    update t_stock_excel_line set rem = v_rem,itid = v_itid,scsts = v_scsts where seid = p_seid and sl = p_sl;

   end if; -- if(v_rem is null) then

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcel_LineAdd` (INOUT `p_id` INT, `p_seid` INT, `p_sl` INT, `p_dt` VARCHAR(15), `p_skid` VARCHAR(10), `p_loc` VARCHAR(40), `p_sloc` VARCHAR(40), `p_ssloc` VARCHAR(40), `p_make` VARCHAR(40), `p_uom` VARCHAR(40), `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_critical` VARCHAR(40), `p_toloc` VARCHAR(40), `p_tosloc` VARCHAR(40), `p_tossloc` VARCHAR(40), `p_wlvl` INT, `p_rlvl` INT, `p_qty` INT, `p_scsts` VARCHAR(10))  BEGIN

if(p_id is null) then

  select ifnull(max(id),10000) + 1 into p_id from t_stock_excel_line;

  insert into t_stock_excel_line(id,seid,sl,skid,dt,loc,sloc,ssloc,make,uom,mtcd
  ,material,critical,qty,toloc,tosloc,tossloc,wlvl,rlvl,scsts) values(
  p_id,
  p_seid,
  p_sl,
  p_skid,
  p_dt,
  p_loc,
  p_sloc,
  p_ssloc,
  p_make,
  p_uom,
  p_mtcd,
  p_material,
  p_critical,
  p_qty,
  p_toloc,
  p_tosloc,
  p_tossloc,
  p_wlvl,
  p_rlvl,
  p_scsts);

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcel_LineAdd_Call` (`p_ss` INT, `p_id` INT, `p_seid` INT, `p_sl` INT, `p_dt` VARCHAR(15), `p_skid` VARCHAR(10), `p_loc` VARCHAR(40), `p_sloc` VARCHAR(40), `p_ssloc` VARCHAR(40), `p_make` VARCHAR(40), `p_uom` VARCHAR(40), `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_critical` VARCHAR(40), `p_toloc` VARCHAR(40), `p_tosloc` VARCHAR(40), `p_tossloc` VARCHAR(40), `p_wlvl` INT, `p_rlvl` INT, `p_qty` INT, `p_scsts` VARCHAR(10))  BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_StockExcel_LineAdd(v_id,p_seid,p_sl,p_dt,p_skid,p_loc,p_sloc,
p_ssloc,p_make,p_uom,p_mtcd,p_material,p_critical,p_toloc,p_tosloc,
p_tossloc,p_wlvl,p_rlvl,p_qty,p_scsts);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockExcel_Line_Backup` (`p_seid` INT, `p_spid` INT, `p_sl` INT, `p_process` VARCHAR(45), `p_cby` VARCHAR(50))  BEGIN

declare v_lcid int default null;

declare v_exists,v_umcf int default null;
declare v_rem,v_sprem varchar(100) default '';
declare v_dt varchar(15);
declare v_itid int;
declare v_mtcd,v_code varchar(20);
declare v_material varchar(200);
declare v_make,v_loc,v_sloc,v_ssloc,v_toloc,v_tosloc,v_tossloc,v_uom varchar(40);
declare v_qty,v_wlvl,v_rlvl int;
declare v_critical varchar(3);
declare v_sublocall varchar(500) default '';
declare v_skid double;
declare v_scsts varchar(1) default 'N';

   select rem into v_rem from t_stock_excel_line where seid = p_seid and sl = p_sl;

   if(v_rem is null) then

    set v_rem = '';

    select FN_StockIDFromExcelID(p_seid,p_sl) into v_skid from t_stock_excel_line where seid = p_seid and sl = p_sl;

    if(v_skid is null) then

      select dt,loc,sloc,ssloc,make,mtcd,material,qty,critical,toloc,tosloc,tossloc,uom,wlvl,rlvl
      into
      v_dt,v_loc,v_sloc,v_ssloc,v_make,v_mtcd,v_material,v_qty,
      v_critical,v_toloc,v_tosloc,v_tossloc,v_uom,v_wlvl,v_rlvl
      from t_stock_excel_line where seid = p_seid and sl = p_sl;

      if (FN_StockExcelValidationCheck(v_dt,p_process,v_mtcd,v_loc,v_sloc,v_ssloc,v_qty,
      v_toloc,v_tosloc,v_tossloc,v_skid)='') then

      if(trim(v_material)!='' and trim(v_critical)!='' and trim(v_uom)!='') then

        select max(id) into v_itid from t_stock_item where
        trim(upper(mtcd)) = upper(trim(v_mtcd)) and upper(trim(material)) = upper(trim(v_material))
        and loc = v_loc and sts = 'Active';

        if (v_itid is null) then

          call PROC_StockItemAdd_Small
          (v_itid,v_mtcd,v_material,v_lcid,v_loc,v_uom,v_critical,str_to_date(v_dt, '%d.%m.%Y'),p_cby,0,v_wlvl,v_rlvl);

          set v_rem = concat('UMC Created : (',v_itid,') : ');

        end if;

      else

          set v_rem = concat('Invalid details please provide (Material,UOM and Critical) : ');

      end if;

     end if;

    else

      select distinct itid,mtcd,material,loc,sloc,ssloc,make,critical,uom
      into
      v_itid,v_mtcd,v_material,v_loc,v_sloc,v_ssloc,v_make,v_critical,v_uom
      from t_stock where skid = v_skid;

      select distinct dt,qty,toloc,tosloc,tossloc
      into
      v_dt,v_qty,v_toloc,v_tosloc,v_tossloc
      from t_stock_excel_line where seid = p_seid and sl = p_sl;

    end if;

    if (v_itid is not null) then

      set v_sprem = FN_StockExcelValidationCheck(
      v_dt,p_process,v_mtcd,v_loc,v_sloc,v_ssloc,v_qty,v_toloc,v_tosloc,v_tossloc,v_skid);

      if (v_sprem = '') then

        select 1 into v_exists from t_stock_process_line
        where spid = p_spid and itid = v_itid and loc = v_loc
        and sloc = v_sloc and ssloc = v_ssloc and make = v_make and critical = v_critical;

        if v_exists is null then

        select code into v_code from t_stock_process_code where process = p_process;

        if (p_process='InternalMovementExcel') then

          set v_sublocall = concat(v_tosloc,':',v_tossloc,':',v_qty);

        end if; -- if (p_process='InternalMovementExcel') then

          call PROC_StockProcessAdd_Line(p_spid,p_sl,str_to_date(v_dt, '%d.%m.%Y'), p_process, v_code, v_loc
          ,v_sloc,v_ssloc,v_make,v_uom,v_itid,v_mtcd,v_material,v_critical,v_qty,NULL,NULL,NULL
          , v_toloc, v_sublocall,NULL,v_skid);

          set v_rem =  concat(v_rem,p_process,' : Done with Quantity ( ',v_qty, ' )');

          set v_scsts = 'Y';

        else -- if v_exists is null then

         set v_rem =  concat(v_rem,'Duplicate Entry Found');

        end if; -- if v_exists is null then

      else -- if (v_sprem = '') then

          set v_rem = concat(v_rem,v_sprem);

     end if; -- if (v_sprem = '') then

   end if;

   update t_stock_excel_line set rem = v_rem,itid = v_itid,scsts = v_scsts where seid = p_seid and sl = p_sl;

  end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockItemAdd` (INOUT `p_id` INT, `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_lcid` INT, `p_loc` VARCHAR(50), `p_make` VARCHAR(50), `p_descp` VARCHAR(100), `p_ittp` VARCHAR(30), `p_rating` VARCHAR(30), `p_uom` VARCHAR(30), `p_omtcd` VARCHAR(20), `p_appl` VARCHAR(30), `p_wlvl` INT, `p_rlvl` INT, `p_critical` VARCHAR(3), `p_cdt` DATETIME, `p_cby` VARCHAR(40), `p_sa` INT)  BEGIN

declare v_skid int default null;

if(p_id is null) then

  select ifnull(max(id),10000) + 1 into p_id from t_stock_item;

  insert into t_stock_item
  (id,mtcd,material,lcid,loc,make,descp,ittp,rating,uom,omtcd,appl,wlvl,rlvl,sts,critical,cdt,cby)
  values(
  p_id,
  p_mtcd,
  p_material,
  p_lcid,
  p_loc,
  p_make,
  p_descp,
  p_ittp,
  p_rating,
  p_uom,
  p_omtcd,
  p_appl,
  p_wlvl,
  p_rlvl,
  'A',
  upper(left(p_critical,1)),
  p_cdt,
  p_cby);

  if (p_sa=1) then

    call PROC_StockProcessAdd(v_skid,'StockAdjustment',NULL,p_loc,NULL,NULL,NULL,NULL,p_cdt,p_cby);
    call PROC_StockProcessAdd_Line(v_skid,1,p_cdt,'StockAdjustment','SA',p_loc,'','',p_make,p_uom,p_id,p_mtcd,p_material
    ,upper(left(p_critical,1)),0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    call PROC_StockSetup(v_skid);

  end if;

else

  update t_stock_item set
  mtcd=p_mtcd,
  material=p_material,
  make=p_make,
  descp=p_descp,
  ittp=p_ittp,
  rating=p_rating,
  uom=p_uom,
  omtcd=p_omtcd,
  appl=p_appl,
  wlvl=p_wlvl,
  rlvl=p_rlvl,
  critical=upper(left(p_critical,1))
  where id = p_id;

  if(p_sa=1) then
    update t_stock set mtcd = p_mtcd,material=p_material,uom=p_uom where itid = p_id;
    update v_stock_base set mtcd = p_mtcd,material=p_material,uom=p_uom where itid = p_id;
  end if;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockItemAdd_Call` (`p_ss` INT, `p_id` INT, `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_lcid` INT, `p_loc` VARCHAR(50), `p_make` VARCHAR(50), `p_descp` VARCHAR(100), `p_ittp` VARCHAR(30), `p_rating` VARCHAR(30), `p_uom` VARCHAR(30), `p_omtcd` VARCHAR(20), `p_appl` VARCHAR(30), `p_wlvl` INT, `p_rlvl` INT, `p_critical` VARCHAR(3), `p_cdt` DATETIME, `p_cby` VARCHAR(40), `p_sa` INT)  BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_StockItemAdd(v_id,p_mtcd,p_material,p_lcid,p_loc,p_make,p_descp,p_ittp,p_rating,p_uom,
p_omtcd,p_appl,p_wlvl,p_rlvl,p_critical,p_cdt,p_cby,p_sa);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockItemAdd_Small` (INOUT `p_id` INT, `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_lcid` INT, `p_loc` VARCHAR(50), `p_uom` VARCHAR(50), `p_critical` VARCHAR(3), `p_cdt` DATETIME, `p_cby` VARCHAR(40), `p_sa` INT, `p_wlvl` INT, `p_rlvl` INT)  BEGIN

declare v_lcid int default null;

select id into v_lcid from t_stock_loc where loc = p_loc;

call PROC_StockItemAdd(p_id,p_mtcd,p_material,v_lcid,p_loc,'',NULL,NULL,NULL,p_uom,
NULL,NULL,p_wlvl,p_rlvl,p_critical,p_cdt,p_cby,p_sa);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockProcessAdd` (INOUT `p_id` INT, `p_process` VARCHAR(40), `p_descp` VARCHAR(200), `p_loc` VARCHAR(50), `p_ispno` VARCHAR(40), `p_isto` VARCHAR(40), `p_tknspno` VARCHAR(40), `p_tknby` VARCHAR(40), `p_dt` DATETIME, `p_cby` VARCHAR(40))  BEGIN

if(p_id is null) then

select ifnull(max(id),20000) + 1 into p_id from t_stock_process;

insert into t_stock_process(id,process,descp,loc,dt,cdt,cby,ispno,isto,tknspno,tknby,sts)
values(
p_id,
p_process,
p_descp,
p_loc,
p_dt,
sysdate(),
p_cby,
p_ispno,
p_isto,
p_tknspno,
p_tknby,
'New');

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockProcessAdd_Call` (`p_ss` INT, `p_id` INT, `p_process` VARCHAR(40), `p_descp` VARCHAR(200), `p_loc` VARCHAR(50), `p_ispno` VARCHAR(40), `p_isto` VARCHAR(40), `p_tknspno` VARCHAR(40), `p_tknby` VARCHAR(40), `p_dt` DATETIME, `p_cby` VARCHAR(40))  BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_StockProcessAdd(v_id,p_process,p_descp,p_loc,p_ispno,p_isto,p_tknspno,p_tknby,p_dt,p_cby);

if(p_ss=1) then
  select v_id;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockProcessAdd_Line` (`p_spid` INT, `p_sl` INT, `p_dt` DATETIME, `p_bprocess` VARCHAR(30), `p_process` VARCHAR(5), `p_loc` VARCHAR(40), `p_sloc` VARCHAR(40), `p_ssloc` VARCHAR(40), `p_make` VARCHAR(40), `p_uom` VARCHAR(40), `p_itid` INT, `p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_critical` VARCHAR(3), `p_qty` INT, `p_pqty` INT, `p_nqty` INT, `p_act` INT, `p_toloc` VARCHAR(40), `p_tosloc` VARCHAR(500), `p_rem` VARCHAR(200), `p_skid` DOUBLE)  BEGIN

insert into t_stock_process_line
(spid,sl,dt,bprocess,process,loc,sloc,ssloc,make,uom,itid,mtcd,material,pqty,qty,nqty,act,toloc,tosloc,
critical,rem,sts,skid)
values(
p_spid,
p_sl,
p_dt,
p_bprocess,
p_process,
p_loc,
p_sloc,
p_ssloc,
p_make,
p_uom,
p_itid,
p_mtcd,
p_material,
p_pqty,
p_qty,
p_nqty,
p_act,
p_toloc,
p_tosloc,
p_critical,
p_rem,
'New',
p_skid);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockQuanityUpdate` (`p_skid` DOUBLE)  BEGIN

declare v_skid double default null;

declare v_itid int;
declare v_mtcd varchar(20);
declare v_material varchar(200);
declare v_make,v_loc,v_sloc,v_ssloc,v_uom varchar(40);
declare v_critical varchar(3);

declare v_sti,v_sto,v_tri,v_tro,v_adi,v_ado,v_scp,v_rsv int default 0;

select ifnull(sum(qty),0) into v_sti from t_stock where skid = p_skid and sts = 'A' and process = 'SI';
select ifnull(sum(qty),0) into v_sto from t_stock where skid = p_skid and sts = 'A' and process = 'SO';
select ifnull(sum(qty),0) into v_tri from t_stock where skid = p_skid and sts = 'A' and process = 'TI';
select ifnull(sum(qty),0) into v_tro from t_stock where skid = p_skid and sts = 'A' and process = 'TO';
select ifnull(sum(qty),0) into v_adi from t_stock where skid = p_skid and sts = 'A' and process = 'AI';
select ifnull(sum(qty),0) into v_ado from t_stock where skid = p_skid and sts = 'A' and process = 'AO';
select ifnull(sum(qty),0) into v_scp from t_stock where skid = p_skid and sts = 'A' and process = 'SCP';
select ifnull(sum(qty),0) into v_rsv from t_stock where skid = p_skid and sts = 'A' and process = 'RSV';

select skid into v_skid from v_stock_base where skid = p_skid;

if(v_skid is null) then


  select distinct itid,mtcd,material,make,loc,sloc,ssloc,uom,critical
  into v_itid,v_mtcd,v_material,v_make,v_loc,v_sloc,v_ssloc,v_uom,v_critical from t_stock where skid = p_skid;

  insert into v_stock_base
  (skid,itid,mtcd,material,make,uom,critical,loc,sloc,ssloc,sts,sti,sto,tri,tro,adi,ado,scp,rsv)
  values
  (p_skid,v_itid,v_mtcd,v_material,v_make,v_uom,v_critical,v_loc,v_sloc,v_ssloc,'A',v_sti,v_sto,v_tri,v_tro,v_adi,v_ado,v_scp,v_rsv);

else


  update v_stock_base set
  sti =  v_sti,
  sto = v_sto,
  tri = v_tri,
  tro = v_tro,
  adi = v_adi,
  ado = v_ado,
  scp = v_scp,
  rsv = v_rsv
  where skid = p_skid;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockSerial` (INOUT `v_skid` DOUBLE, INOUT `v_sl` INT, `v_itid` INT, `v_material` VARCHAR(200), `v_loc` VARCHAR(30), `v_sloc` VARCHAR(30), `v_ssloc` VARCHAR(30), `v_make` VARCHAR(30), `v_critical` VARCHAR(3))  BEGIN

  select max(skid) into v_skid from t_stock where itid = v_itid and material = v_material
  and loc = v_loc and sloc = v_sloc and ssloc = v_ssloc and make = v_make and critical = v_critical;

  if (v_skid is null) then

    select ifnull(max(skid),100000) + 1 into v_skid from t_stock;
    set v_sl = 1;

  else

      select max(sl) + 1 into v_sl from t_stock where skid = v_skid;

  end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockSetup` (`p_spid` INT)  BEGIN

  declare i,ti int;

  declare v_sl int;

  declare v_dt datetime;

  declare v_bprocess,v_bsts,v_cby varchar(45);

  declare Component_CR cursor for select sl from t_stock_process_line where spid = p_spid order by sl;

  select sts,process,cby,dt into v_bsts,v_bprocess,v_cby,v_dt from t_stock_process where id = p_spid and sts = 'New';

  select count(*) into ti from t_stock_process_line where spid = p_spid;

  if(v_bsts is not null) then

  set i = 1;

  OPEN Component_CR;

      Component:LOOP

      IF i <= ti THEN

         FETCH Component_CR INTO v_sl;

         call PROC_StockSetup_Line(p_spid,v_sl,v_cby);

         ELSE

          LEAVE Component;

         END IF;

        set i = i + 1;

      END LOOP Component;

  CLOSE Component_CR;

  update t_stock_process set sts = 'Released' where id = p_spid and sts = 'New';

 end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockSetup_Line` (`p_spid` INT, `p_sl` INT, `p_cby` VARCHAR(20))  BEGIN

  declare v_skid double default null;
  declare v_sl,v_cqty,tosloc_i int;

  declare v_id double;

  declare v_bprocess varchar(30);

  declare v_process,v_t_process varchar(10);
  declare v_itid int;
  declare v_mtcd varchar(20);
  declare v_material,v_rem varchar(200);
  declare v_make,v_loc,v_sloc,v_ssloc,v_toloc,v_uom varchar(30);
  declare v_qty,v_act int;
  declare v_issueto,v_takenby varchar(50);
  declare v_dt datetime;
  declare v_critical varchar(3);

  declare tosloc_all varchar(500);
  declare tosloc_s varchar(50);

  select dt,bprocess,process,loc,sloc,ssloc,make,itid,mtcd,material,qty,toloc,act,critical,tosloc,uom,skid,rem
  into
  v_dt,v_bprocess,v_process,v_loc,v_sloc,v_ssloc,v_make,v_itid,v_mtcd,v_material,v_qty,v_toloc
  ,v_act,v_critical,tosloc_all,v_uom,v_skid,v_rem
  from t_stock_process_line where spid = p_spid and sl = p_sl;

  IF v_process = 'SA' OR v_process = 'SAE' then

    set v_cqty = FN_StockQtyFromID(v_skid);

    if(v_cqty is null) then

        set v_t_process = 'AI';
        set v_act = v_qty;

    elseif(v_cqty>v_qty) then

        set v_t_process = 'AO';
        set v_act = v_cqty - v_qty;

    else

        set v_t_process = 'AI';
        set v_act = v_qty - v_cqty;

    end if;

    call PROC_StockAdd(v_skid,v_bprocess,v_t_process,v_loc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
    ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,v_act,v_rem);

  ELSEIF v_process = 'IM' or v_process = 'IME' or v_process = 'IMS' then

   call PROC_StockAdd(v_skid,v_bprocess,'TO',v_loc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
   ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,v_qty,v_rem);

   set tosloc_i = 1;

   while(tosloc_i<=FN_CommonNoOfOccur(tosloc_all,',') + 1)
   do

   SET tosloc_s = FN_CommonSplitString(tosloc_all,',',tosloc_i);

     call PROC_StockAdd(v_skid,v_bprocess,'TI',v_loc,FN_CommonSplitString(tosloc_s,':',1)
     ,FN_CommonSplitString(tosloc_s,':',2),v_itid,v_mtcd,v_material,v_make,v_uom,
     v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,FN_CommonSplitString(tosloc_s,':',3),v_rem);

     set tosloc_i = tosloc_i + 1;

   end while;

  ELSEIF v_process = 'ST' OR v_process = 'STE' then

    call PROC_StockAdd(v_skid,v_bprocess,'TO',v_loc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
    ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,v_qty,v_rem);

    call PROC_StockAdd(v_skid,v_bprocess,'TI',v_toloc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
    ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_loc,v_dt,p_cby,p_spid,p_sl,v_qty,v_rem);

 ELSEIF v_process = 'SO' then

   select concat(ispno,' : ',isto),concat(tknspno,' : ',tknby),dt into v_issueto,v_takenby,v_dt  from t_stock_process where id = p_spid;

   call PROC_StockAdd(v_skid,v_bprocess,v_process,v_loc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
    ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,v_qty,v_rem);

 ELSE

  if(v_process='SIE') then
    set  v_process = 'SI';
  end if;

  if(v_process='SCPE') then
    set  v_process = 'SCP';
  end if;

  call PROC_StockAdd(v_skid,v_bprocess,v_process,v_loc,v_sloc,v_ssloc,v_itid,v_mtcd,v_material
  ,v_make,v_uom,v_critical,v_issueto,v_takenby,v_toloc,v_dt,p_cby,p_spid,p_sl,v_qty,v_rem);

 END IF;

 update t_stock_process_line set sts = 'Released' where sts = 'New' and spid = p_spid and sl = p_sl;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PROC_StockSetup_List` (`lst` VARCHAR(5000))  BEGIN

DECLARE prd_cmp int DEFAULT NULL; 

DECLARE i,ll INT DEFAULT 1;  

SET ll = FUN_NoOfOccur(lst,',') + 1;

while(i<=ll)
do

SET prd_cmp = FUN_SplitString(lst,',',i);

 call PROC_StockSetup(prd_cmp);

set i = i + 1;

end while;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CommonMondayPrev` () RETURNS DATE BEGIN

return DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY);

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CommonNoOfOccur` (`mnString` VARCHAR(5000), `Delim` VARCHAR(12)) RETURNS INT(11) BEGIN

RETURN FLOOR((CHAR_LENGTH(mnString) - CHAR_LENGTH( REPLACE (mnString, Delim, '') )) / CHAR_LENGTH(Delim));

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CommonSplitString` (`mnString` VARCHAR(5000), `Delim` VARCHAR(12), `Pos` INT) RETURNS VARCHAR(30) CHARSET latin1 BEGIN

RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(mnString, Delim, Pos),
       LENGTH(SUBSTRING_INDEX(mnString, Delim, Pos -1)) + 1),
       Delim, '');

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_CommonSundayNext` () RETURNS DATE BEGIN

return date_add(FN_CommonMondayPrev(), INTERVAL 6 day);

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_Mast_SubLocation` (`p_proc` VARCHAR(20), `p_id` INT, `p_sloc` VARCHAR(40), `p_lcid` INT, `p_loc` VARCHAR(50)) RETURNS INT(11) BEGIN

declare v_id int;

if(p_proc='Save') then

  if(p_id is null) then

    select ifnull(max(id),1) + 1 into v_id from t_stock_sub_loc;

    insert into t_stock_sub_loc
    (id,sloc,lcid,loc)
    values(
    v_id,
    p_sloc,
    p_lcid,
    p_loc);

  else

    update t_stock_sub_loc
    set sloc = p_sloc where id = p_id;

    set v_id = p_id;

  end if;

end if;

if(p_proc='Delete') then

    delete from t_stock_sub_loc
    where id = p_id;

    set v_id = p_id;

end if;


return v_id;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockExcelValidationCheck` (`p_dt` VARCHAR(15), `p_process` VARCHAR(30), `p_mtcd` VARCHAR(20), `p_loc` VARCHAR(40), `p_sloc` VARCHAR(40), `p_ssloc` VARCHAR(40), `p_qty` INT, `p_toloc` VARCHAR(40), `p_tosloc` VARCHAR(40), `p_tossloc` VARCHAR(40), `p_skid` DOUBLE) RETURNS VARCHAR(100) CHARSET latin1 BEGIN

declare v_slocid,v_sslocid,v_tolocid,v_toslocid,v_tosslocid int default null;
declare v_umcf int default null;
declare v_nqty int;

if(p_qty>99999) then

  return concat(p_qty,' : Stock Quanity Cannot Be Greater Than 99,999 ! ');

end if;



if(str_to_date(p_dt, '%d.%m.%Y') is null) then

  return concat(p_dt,' : Invalid Date Format (dd.MM.yyyy) ! ');

end if;


set v_umcf = FN_StockUMCFormatCheck(p_mtcd);

if(v_umcf=0) then

  return concat(p_mtcd,' : Invalid UMC Number ! ');

end if;


if (p_sloc!='') then
   select max(id) into v_slocid from t_stock_sub_loc where upper(sloc) = trim(upper(p_sloc)) and loc = p_loc;
else
   set v_slocid = 0;
end if;

if (v_slocid is null) then

  return concat(p_sloc,' : Sub Location Not Found ');

end if;

if (p_ssloc!='') then
   select max(id) into v_sslocid from t_stock_rack where upper(ssloc) = trim(upper(p_ssloc)) and loc = p_loc;
else
   set v_sslocid = 0;
end if;


if (v_sslocid is null) then

  return concat(p_ssloc,' : Rack Not Found ');

end if;

if (p_toloc!='') then
   select max(id) into v_tolocid from t_stock_loc where upper(loc) = trim(upper(p_toloc));
else
   set v_tolocid = 0;
end if;



if(p_process='StockTransferExcel') then
  if (v_tolocid is null) then

    return concat(p_toloc,' : Transfer Location Not Found ');

  end if;
end if;


if(p_process='InternalMovementExcel') then

  if (p_tosloc!='') then
     select max(id) into v_toslocid from t_stock_sub_loc where upper(sloc) = trim(upper(p_tosloc)) and loc = p_loc;
  else
     set v_toslocid = 0;
  end if;

  if (v_toslocid is null) then

    return concat(p_tosloc,' : Transfer Sub Location Not Found ');

  end if;

  if (p_tossloc!='') then
     select max(id) into v_tosslocid from t_stock_rack where upper(ssloc) = trim(upper(p_tossloc)) and loc = p_loc;
  else
     set v_tosslocid = 0;
  end if;


  if (v_tosslocid is null) then

    return concat(p_tossloc,' : Transfer Rack Not Found ');

  end if;


  if(p_sloc = p_tosloc and p_ssloc = p_tossloc) then
    return 'Transfer Sub Location and Rack is Same for Source and Destination';
  end if;

end if;

if (p_process='StockAdjustmentExcel') then
  if (p_qty = FN_StockQtyFromID(p_skid)) then
    return concat(p_qty,' : Current Quantity is as same Adjustment Quantity');
  end if;
end if;


if (p_process='StockTransferExcel' or p_process='StockSCRAPExcel' or p_process='InternalMovementExcel') then
  set v_nqty = FN_StockQtyFromID(p_skid);
  if(v_nqty is null) then
      return concat('Stock not available for given Stock Item');
  elseif (p_qty > v_nqty) then
    return concat(p_qty,' : Issue Quantity is greater than Avalable Quanity : ',v_nqty);
  end if;
end if;


return '';

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockIDFromDetails` (`p_mtcd` VARCHAR(20), `p_material` VARCHAR(200), `p_loc` VARCHAR(40), `p_sloc` VARCHAR(40), `p_ssloc` VARCHAR(40), `p_make` VARCHAR(40), `p_critical` VARCHAR(3)) RETURNS INT(11) BEGIN

declare v_qty int default null;
declare v_critical varchar(3);

if(p_critical is null or trim(p_critical) = '') then
  set v_critical = 'N';
else
  set v_critical = p_critical;
end if;

select distinct(skid) into v_qty from t_stock where
mtcd = p_mtcd and material = p_material and loc = p_loc and sloc = p_sloc and ssloc = p_ssloc and make = p_make
and critical = v_critical and sts = 'A';

return v_qty;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockIDFromExcelID` (`p_seid` INT, `p_sl` INT) RETURNS DOUBLE BEGIN

declare v_str_skid varchar(15) default null;
declare v_skid double default null;

declare v_mtcd varchar(20);
declare v_material varchar(200);
declare v_make,v_loc,v_sloc,v_ssloc,v_uom varchar(40);
declare v_critical varchar(3);

select mtcd,material,make,uom,critical,loc,sloc,ssloc,skid
      into
      v_mtcd,v_material,v_make,v_uom,v_critical,v_loc,v_sloc,v_ssloc,v_str_skid
      from t_stock_excel_line where seid = p_seid and sl = p_sl;

if (v_str_skid REGEXP '^[0-9]+$') = 0 then
  return null;
end if;

select max(skid) into v_skid from t_stock where skid = cast(v_str_skid as double);

if(v_skid is null) then

select max(skid) into v_skid from t_stock
where mtcd = v_mtcd and material = v_material and make = v_make and uom = v_uom
and critical = v_critical and loc = v_loc and sloc = v_sloc and ssloc = v_ssloc and sts = 'A';

end if;

return v_skid;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockProcessAdd_Call` (`p_id` INT, `p_process` VARCHAR(40), `p_descp` VARCHAR(200), `p_loc` VARCHAR(50), `p_ispno` VARCHAR(40), `p_isto` VARCHAR(40), `p_tknspno` VARCHAR(40), `p_tknby` VARCHAR(40), `p_dt` DATETIME, `p_cby` VARCHAR(40)) RETURNS INT(11) BEGIN

declare v_id int default null;

call PROC_StockProcessAdd(
v_id,p_process,p_descp,p_loc,p_ispno,p_isto,p_tknspno,p_tknby,p_dt,p_cby);

return v_id;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockQtyFromID` (`p_skid` DOUBLE) RETURNS INT(11) BEGIN

declare v_qty int default null;

select avl into v_qty from v_stock where skid = p_skid and sts = 'A';

return v_qty;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FN_StockUMCFormatCheck` (`p_umcno` VARCHAR(9)) RETURNS INT(11) BEGIN

declare v_len int;

declare v_ch varchar(1);

declare vi int;

set p_umcno = upper(p_umcno);

select length(p_umcno) into v_len;

if(v_len=0) then

return 1;

end if;

if(v_len!=9) then

  return 0;

else

  set vi = 1;

  while(vi<=9)
  do

    set v_ch = substr(p_umcno,vi,1);

    if(vi=5) then

      if not (v_ch>='A' and v_ch<='Z') then

        return 0;

      end if;

    else

      if not (v_ch>='0' and v_ch<='9') then

        return 0;

      end if;

    end if;

    set vi = vi + 1;

  end while;

end if;

return 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `PC_MT_Company_FN` (`p_proc` VARCHAR(20), `p_id` INT, `p_cmpcd` VARCHAR(10), `p_company` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_dt` DATETIME) RETURNS INT(11) BEGIN

declare v_id int default null;

set v_id = p_id;

call PC_MT_Company(p_proc,v_id,p_cmpcd,p_company,p_sts
,p_cbid,p_cby,p_dt);

return v_id;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `PC_MT_Plant_FN` (`p_proc` VARCHAR(20), `p_id` INT, `p_cmpid` INT, `p_cmpcd` VARCHAR(10), `p_plntcd` VARCHAR(10), `p_plant` VARCHAR(50), `p_sts` VARCHAR(15), `p_cbid` INT, `p_cby` VARCHAR(30), `p_cdt` DATETIME) RETURNS INT(11) BEGIN

declare v_id int;

set v_id = p_id;

call PC_MT_Plant(p_proc,v_id,p_cmpid,p_cmpcd,p_plntcd,p_plant,p_sts
,p_cbid,p_cby,p_cdt);

return v_id;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `PROC_StockExcelAdd_Call_FN` (`p_id` INT, `p_process` VARCHAR(20), `p_dt` DATE, `p_lcid` INT, `p_loc` VARCHAR(50), `p_rem` VARCHAR(200), `p_sts` VARCHAR(30), `p_cby` VARCHAR(30), `p_cdt` DATETIME) RETURNS INT(11) BEGIN

declare v_id int default null;

set v_id = p_id;

call PROC_StockExcelAdd(v_id,p_process,p_dt,p_lcid,p_loc
, p_rem,p_sts,p_cby,p_cdt);

return v_id;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_log_recorded`
--

CREATE TABLE `t_log_recorded` (
  `id` int(10) UNSIGNED NOT NULL,
  `msg` varchar(300) DEFAULT NULL,
  `prcs` varchar(50) DEFAULT NULL,
  `prcstg` varchar(50) DEFAULT NULL,
  `objt` varchar(40) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `unm` varchar(50) DEFAULT NULL,
  `dt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_log_recorded`
--

INSERT INTO `t_log_recorded` (`id`, `msg`, `prcs`, `prcstg`, `objt`, `uid`, `unm`, `dt`) VALUES
(1, 'INSERT', 'INSERT', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 22:30:26'),
(2, 'UPDATE', 'UPDATE', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 22:31:18'),
(3, 'DELETED', 'DELETED', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 22:31:51'),
(4, '3', 'INSERT', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 22:51:33'),
(5, '4', 'INSERT', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 23:16:34'),
(6, 'INSERTED', 'INSERTED', 'SUCCESS', 'T_STOCK_COMPANY', 1, 'ADMIN', '2024-07-21 23:21:18'),
(7, 'INSERTED', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-21 23:21:48'),
(8, '3', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-21 23:22:14'),
(9, '4', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-21 23:23:12'),
(10, '1', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-27 17:37:31'),
(11, '2', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-27 17:39:05'),
(12, '1', 'INSERTED', 'SUCCESS', 'T_STOCK_PLANT', 1, 'ADMIN', '2024-07-27 17:40:00');

-- --------------------------------------------------------

--
-- Table structure for table `t_process_log`
--

CREATE TABLE `t_process_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `msg` varchar(300) DEFAULT NULL,
  `prcs` varchar(50) DEFAULT NULL,
  `objt` varchar(40) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `unm` varchar(50) DEFAULT NULL,
  `dt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock`
--

CREATE TABLE `t_stock` (
  `id` double NOT NULL,
  `skid` double NOT NULL,
  `sl` int(11) NOT NULL,
  `bprocess` varchar(30) DEFAULT NULL,
  `process` varchar(10) DEFAULT NULL,
  `itid` int(11) NOT NULL,
  `mtcd` varchar(45) NOT NULL,
  `material` varchar(150) NOT NULL,
  `loc` varchar(40) NOT NULL,
  `sloc` varchar(40) NOT NULL,
  `ssloc` varchar(40) NOT NULL,
  `make` varchar(40) NOT NULL,
  `uom` varchar(30) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `critical` varchar(5) DEFAULT NULL,
  `tloc` varchar(50) DEFAULT NULL,
  `issueto` varchar(50) DEFAULT NULL,
  `takenby` varchar(50) DEFAULT NULL,
  `rem` varchar(200) DEFAULT NULL,
  `dt` datetime DEFAULT NULL,
  `cdt` datetime DEFAULT NULL,
  `cby` varchar(45) DEFAULT NULL,
  `spid` int(10) UNSIGNED DEFAULT NULL,
  `spsl` int(10) UNSIGNED DEFAULT NULL,
  `sts` varchar(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock`
--

INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(700001, 100001, 1, 'StockAdjustmentExcel', 'AI', 10001, '', '3 PAIR X0.5 CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 1, 'A'),
(700002, 100002, 1, 'StockAdjustmentExcel', 'AI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 2, 'A'),
(700003, 100003, 1, 'StockAdjustmentExcel', 'AI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 3, 'A'),
(700004, 100004, 1, 'StockAdjustmentExcel', 'AI', 10004, '0025C0092', 'BRG ROLLER SINGLE ROW CYL MET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 4, 'A'),
(700005, 100005, 1, 'StockAdjustmentExcel', 'AI', 10005, '0030A0051', 'BRG.ROLLER,DOUBLE ROW,  23136,CCW33', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 5, 'A'),
(700006, 100006, 1, 'StockAdjustmentExcel', 'AI', 10006, '0030B0068', 'BRG.ROLLER,DOUBLE ROW,SP 22226 CCW33', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 6, 'A'),
(700007, 100007, 1, 'StockAdjustmentExcel', 'AI', 10007, '0031A0160', 'BRG. 32312 TAPER ROLLER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 7, 'A'),
(700008, 100008, 1, 'StockAdjustmentExcel', 'AI', 10008, '0031B0007', 'BRG.ROLLERTAPER,SINGLEROW,METRIC(31309,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 8, 'A'),
(700009, 100009, 1, 'StockAdjustmentExcel', 'AI', 10009, '0083A0023', 'TYRE TYPE COUPING & SPARES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 9, 'A'),
(700010, 100010, 1, 'StockAdjustmentExcel', 'AI', 10010, '0088A0095', 'THREADED CABLE GLAND SIZE M20X1.5', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 10, 'A'),
(700011, 100011, 1, 'StockAdjustmentExcel', 'AI', 10011, '0093A0119', 'CABLE GLAND  19 MM', 'Toolkit Store', '', '', '', 'NOS', 266, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 11, 'A'),
(700012, 100012, 1, 'StockAdjustmentExcel', 'AI', 10012, '0093A0120', 'CABLE GLAND  22MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 12, 'A'),
(700013, 100013, 1, 'StockAdjustmentExcel', 'AI', 10013, '0096A0138', 'NUTM16', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 13, 'A'),
(700014, 100014, 1, 'StockAdjustmentExcel', 'AI', 10014, '0101D0096', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 35MM\"', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 14, 'A'),
(700015, 100015, 1, 'StockAdjustmentExcel', 'AI', 10015, '0101D0097', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 40MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 15, 'A'),
(700016, 100016, 1, 'StockAdjustmentExcel', 'AI', 10016, '0101D0099', '\"HEX HEAD, HIGH TENSILE BOLT, 8MM, 50MM\"', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 16, 'A'),
(700017, 100017, 1, 'StockAdjustmentExcel', 'AI', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', 'Toolkit Store', '', '', '', 'NOS', 29, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 17, 'A'),
(700018, 100018, 1, 'StockAdjustmentExcel', 'AI', 10018, '0122B0064', 'SAFETY ITEMS ( BARICADE  TAPE)', 'Toolkit Store', '', '', '', 'NOS', 142, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 18, 'A'),
(700019, 100019, 1, 'StockAdjustmentExcel', 'AI', 10019, '0124A0003', 'HANDGLAVES (LEATHER CUM CANVAS)', 'Toolkit Store', '', '', '', 'PAA', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 19, 'A'),
(700020, 100020, 1, 'StockAdjustmentExcel', 'AI', 10020, '0150A0025', 'BREATHING APPARATUS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 20, 'A'),
(700021, 100021, 1, 'StockAdjustmentExcel', 'AI', 10021, '0162A0003', 'BULLDOG GRIP 13 MM WIRE ROPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 21, 'A'),
(700022, 100022, 1, 'StockAdjustmentExcel', 'AI', 10022, '0162A0004', 'BULLDOG GRIP 16MM WIRE ROPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 22, 'A'),
(700023, 100023, 1, 'StockAdjustmentExcel', 'AI', 10023, '0162A0007', 'BULLDOG GRIP  25mm', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 23, 'A'),
(700024, 100024, 1, 'StockAdjustmentExcel', 'AI', 10024, '0177A0733', 'Ferrule for 6mm OD x 1mm thick', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 24, 'A'),
(700025, 100025, 1, 'StockAdjustmentExcel', 'AI', 10025, '0207A0048', 'GENERAL TOOLS   -plie', 'Toolkit Store', '', '', '', 'NOS', 25, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 25, 'A'),
(700026, 100026, 1, 'StockAdjustmentExcel', 'AI', 10026, '0217A0039', 'MOT.LEAD,1KV,CU,16X1C,HRE ELSTMR INSL', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 26, 'A'),
(700027, 100027, 1, 'StockAdjustmentExcel', 'AI', 10027, '0217A0042', 'FLEX.CABLE,1KV,CU,70X1C,HRE INSULN.', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 27, 'A'),
(700028, 100028, 1, 'StockAdjustmentExcel', 'AI', 10028, '0217A0044', 'FLEX CABLE,1KV,CU,120 X1C ,HRE,INSULN', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 28, 'A'),
(700029, 100029, 1, 'StockAdjustmentExcel', 'AI', 10029, '0217A0045', 'FLEX CABLE,1 KV,CU,150X1C,HRE INSULN', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 29, 'A'),
(700030, 100030, 1, 'StockAdjustmentExcel', 'AI', 10030, '0217A0046', 'FLEX CABLE 1 KV CU 240*1C HRE INSULN', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 30, 'A'),
(700031, 100031, 1, 'StockAdjustmentExcel', 'AI', 10031, '0217A0049', 'FLEX LEAD,1 KV,CU,2.5X1C,HRE INSULN', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 31, 'A'),
(700032, 100032, 1, 'StockAdjustmentExcel', 'AI', 10032, '0237A0081', 'GL.PRPS,FLEX,1KV,CU,2.5X4C,RUBR,RUBR SH', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 32, 'A'),
(700033, 100033, 1, 'StockAdjustmentExcel', 'AI', 10033, '0237A0082', 'GL PRPS FLEX,1KV,CU,6X4C,RUBR,RUBR SH', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 33, 'A'),
(700034, 100034, 1, 'StockAdjustmentExcel', 'AI', 10034, '0237A0087', 'MAGNET CABLE 35SQMM X 2C CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 34, 'A'),
(700035, 100035, 1, 'StockAdjustmentExcel', 'AI', 10035, '0237A0090', 'CABLE FOR LIGHTING PURPOSE,1.5SQ.MM', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 35, 'A'),
(700036, 100036, 1, 'StockAdjustmentExcel', 'AI', 10036, '0244A0061', 'CONTACTOR POWER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 36, 'A'),
(700037, 100037, 1, 'StockAdjustmentExcel', 'AI', 10037, '0244A0084', 'CONTACTOR POWER', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 37, 'A'),
(700038, 100038, 1, 'StockAdjustmentExcel', 'AI', 10038, '0244A0155', '3 POLE 300A CONTACTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 38, 'A'),
(700039, 100039, 1, 'StockAdjustmentExcel', 'AI', 10039, '0244A0167', 'CONTACTOR RELAY 2NO+2NC', 'Toolkit Store', '', '', '', 'NOS', 71, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 39, 'A'),
(700040, 100040, 1, 'StockAdjustmentExcel', 'AI', 10040, '0244A0496', 'CONTACTOR,110A,110VAC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 40, 'A'),
(700041, 100041, 1, 'StockAdjustmentExcel', 'AI', 10041, '0244A0586', 'DS PLUG 16AMPS', 'Toolkit Store', '', '', '', 'NOS', 39, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 41, 'A'),
(700042, 100042, 1, 'StockAdjustmentExcel', 'AI', 10042, '0244A0587', 'DS SOCKET 16AMPS', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 42, 'A'),
(700043, 100043, 1, 'StockAdjustmentExcel', 'AI', 10043, '0244A0658', 'HRC 16A HF', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 43, 'A'),
(700044, 100044, 1, 'StockAdjustmentExcel', 'AI', 10044, '0244A0665', 'HRC 200A SIZE I', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:33', 'usertool', 20001, 44, 'A'),
(700045, 100045, 1, 'StockAdjustmentExcel', 'AI', 10045, '0244A0844', 'POWER CONTRACTORS 3 POLE AC CONTROL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 45, 'A'),
(700046, 100046, 1, 'StockAdjustmentExcel', 'AI', 10046, '0244A0858', 'CONTACTOR: 300 AMPS', 'Toolkit Store', '', '', '', 'NOS', 7, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 46, 'A'),
(700047, 100047, 1, 'StockAdjustmentExcel', 'AI', 10047, '0244A0928', 'CONTACTOR MNX45, 110V', 'Toolkit Store', '', '', '', 'NOS', 12, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 47, 'A'),
(700048, 100048, 1, 'StockAdjustmentExcel', 'AI', 10048, '0244A0958', 'SIEMENS CONTACTOR,110VAC,3TF3200-OAFO', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 48, 'A'),
(700049, 100049, 1, 'StockAdjustmentExcel', 'AI', 10049, '0244A0960', 'SIEMENS CONTACTOR,415VAC,3TF3400-OARO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 49, 'A'),
(700050, 100050, 1, 'StockAdjustmentExcel', 'AI', 10050, '0244A0961', 'SlEMENS CONTACTOR,220VAC,3TF3400-OAMO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 50, 'A'),
(700051, 100051, 1, 'StockAdjustmentExcel', 'AI', 10051, '0244A0962', 'ACTUATOR,2NC', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 51, 'A'),
(700052, 100052, 1, 'StockAdjustmentExcel', 'AI', 10052, '0244A0964', 'SIEMENS CONTACTOR,220VAC,3TF4822-OAPO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 52, 'A'),
(700053, 100053, 1, 'StockAdjustmentExcel', 'AI', 10053, '0244A0965', 'SIEMENS CONTACTOR,110VAC,3TF4822-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 53, 'A'),
(700054, 100054, 1, 'StockAdjustmentExcel', 'AI', 10054, '0244A0968', 'SIEMENS CONTACTOR,110VAC,3TF5202-OAFO', 'Toolkit Store', '', '', '', 'NOS', 14, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 54, 'A'),
(700055, 100055, 1, 'StockAdjustmentExcel', 'AI', 10055, '0244A0969', 'SIEMENS CONTACTOR,110VAC,3TF5600-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 55, 'A'),
(700056, 100056, 1, 'StockAdjustmentExcel', 'AI', 10056, '0244A0973', 'SIEMENS CONTACTOR,110VAC,3TF3010-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 56, 'A'),
(700057, 100057, 1, 'StockAdjustmentExcel', 'AI', 10057, '0244A0976', 'SIEMENS CONTACTOR,110VAC,3TH3022-OAFO', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 57, 'A'),
(700058, 100058, 1, 'StockAdjustmentExcel', 'AI', 10058, '0244A1002', 'SIEMENS CONTACTOR,10A,110V,3TF3010-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 58, 'A'),
(700059, 100059, 1, 'StockAdjustmentExcel', 'AI', 10059, '0244A1005', 'SIEMENS CONTACTOR,16A,110V,3TF3110-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 59, 'A'),
(700060, 100060, 1, 'StockAdjustmentExcel', 'AI', 10060, '0244A1074', 'SIEMENS CONTACTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 60, 'A'),
(700061, 100061, 1, 'StockAdjustmentExcel', 'AI', 10061, '0244A1140', 'VACUUM CONTACTOR 820A 220V AC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 61, 'A'),
(700062, 100062, 1, 'StockAdjustmentExcel', 'AI', 10062, '0244F0093', 'POWER CONTACTOR 420 AMPS.WITH 110 VOLTS', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 62, 'A'),
(700063, 100063, 1, 'StockAdjustmentExcel', 'AI', 10063, '0248A0021', 'CONTACT, ELECTRICAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 63, 'A'),
(700064, 100064, 1, 'StockAdjustmentExcel', 'AI', 10064, '0248A0117', 'ADD ON BLOCK FOR D2 & F RANGE CONTACTORS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 64, 'A'),
(700065, 100065, 1, 'StockAdjustmentExcel', 'AI', 10065, '0248A0249', 'CONTACT KIT FOR 3 TF 50', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 65, 'A'),
(700066, 100066, 1, 'StockAdjustmentExcel', 'AI', 10066, '0248A0253', 'CONTACT SET FOR 3TF54', 'Toolkit Store', '', '', '', 'NOS', 4, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 66, 'A'),
(700067, 100067, 1, 'StockAdjustmentExcel', 'AI', 10067, '0255A0654', '0CCB', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 67, 'A'),
(700068, 100068, 1, 'StockAdjustmentExcel', 'AI', 10068, '0256A0128', 'MCB,2 POLE,16AMPS C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 68, 'A'),
(700069, 100069, 1, 'StockAdjustmentExcel', 'AI', 10069, '0256A0131', 'MCB,2 POLE,32AMPS C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 69, 'A'),
(700070, 100070, 1, 'StockAdjustmentExcel', 'AI', 10070, '0256A0132', 'MCB,2 POLE,40AMPS C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 70, 'A'),
(700071, 100071, 1, 'StockAdjustmentExcel', 'AI', 10071, '0256A0215', 'MERLIN GERIN MCB 1POLE 2A C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 71, 'A'),
(700072, 100072, 1, 'StockAdjustmentExcel', 'AI', 10072, '0256A0218', 'MERLIN GERIN MCB 1POLE 6A C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 72, 'A'),
(700073, 100073, 1, 'StockAdjustmentExcel', 'AI', 10073, '0256A0220', 'MERLIN GERIN MCB 1POLE 16A C CURVE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 73, 'A'),
(700074, 100074, 1, 'StockAdjustmentExcel', 'AI', 10074, '0256A0288', 'MERLIN GERIN RCBO 16A C CURVE - 2 POLE 3', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 74, 'A'),
(700075, 100075, 1, 'StockAdjustmentExcel', 'AI', 10075, '0256A0290', 'MERLIN GERIN RCBO 25A C CURVE - 2 POLE 3', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 75, 'A'),
(700076, 100076, 1, 'StockAdjustmentExcel', 'AI', 10076, '0256A0291', 'MERLIN GERIN RCBO 32A C CURVE - 2 POLE 3', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 76, 'A'),
(700077, 100077, 1, 'StockAdjustmentExcel', 'AI', 10077, '0256A1517', '550A 3 POLE POWER CONTACTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 77, 'A'),
(700078, 100078, 1, 'StockAdjustmentExcel', 'AI', 10078, '0256A1529', '200AMPS MCCB WITH ROTARY HANDLE', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 78, 'A'),
(700079, 100079, 1, 'StockAdjustmentExcel', 'AI', 10079, '0257L0084', 'OIL SEAL, 52 MM, 40 MM, 7 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 79, 'A'),
(700080, 100080, 1, 'StockAdjustmentExcel', 'AI', 10080, '0274A0102', 'SPLIT PIN FOR VI MECHANISM OF LF', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 80, 'A'),
(700081, 100081, 1, 'StockAdjustmentExcel', 'AI', 10081, '0278A0025', 'DOOR FITTINGS', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 81, 'A'),
(700082, 100082, 1, 'StockAdjustmentExcel', 'AI', 10082, '0289A0067', 'CO GAS DETECTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 82, 'A'),
(700083, 100083, 1, 'StockAdjustmentExcel', 'AI', 10083, '0291B0022', 'POWDER CLEANING', 'Toolkit Store', '', '', '', 'LIT', 22, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 83, 'A'),
(700084, 100084, 1, 'StockAdjustmentExcel', 'AI', 10084, '0291D0018', 'MISCELLANEOUS ITEMS (Godrej LOCK 8 lever', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 84, 'A'),
(700085, 100085, 1, 'StockAdjustmentExcel', 'AI', 10085, '0344A0007', 'CONDENSER FOR POWER CIRCUITS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 85, 'A'),
(700086, 100086, 1, 'StockAdjustmentExcel', 'AI', 10086, '0356A0054', '\"MCB DISTRIBUTION BOARD,12 WAY WITH WIRI', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 86, 'A'),
(700087, 100087, 1, 'StockAdjustmentExcel', 'AI', 10087, '0358A0032', 'PLUG FOR ELECT. POWER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 87, 'A'),
(700088, 100088, 1, 'StockAdjustmentExcel', 'AI', 10088, '0358A0083', 'METAL CLAD PLUG 20A 3 P', 'Toolkit Store', '', '', '', 'NOS', 166, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 88, 'A'),
(700089, 100089, 1, 'StockAdjustmentExcel', 'AI', 10089, '0359A0016', 'HIGH POWER LED TORCH LIGHT', 'Toolkit Store', '', '', '', 'NOS', 30, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 89, 'A'),
(700090, 100090, 1, 'StockAdjustmentExcel', 'AI', 10090, '0362A0743', 'HALOGEN LAMP 500W', 'Toolkit Store', '', '', '', 'NOS', 13, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 90, 'A'),
(700091, 100091, 1, 'StockAdjustmentExcel', 'AI', 10091, '0365a0002', 'CALLING BELL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 91, 'A'),
(700092, 100092, 1, 'StockAdjustmentExcel', 'AI', 10092, '0367A0155', '160 WATT PROGRAMMABLE HOOTER', 'Toolkit Store', '', '', '', 'NOS', 11, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 92, 'A'),
(700093, 100093, 1, 'StockAdjustmentExcel', 'AI', 10093, '0380B0038', '\"LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 93, 'A'),
(700094, 100094, 1, 'StockAdjustmentExcel', 'AI', 10094, '0380B0038', 'LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 94, 'A'),
(700095, 100095, 1, 'StockAdjustmentExcel', 'AI', 10095, '0394A0058', 'ALUMINIUM FOIL TAPE SIZE 5 CM X 10 MTR.', 'Toolkit Store', '', '', '', 'NOS', 972, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 95, 'A'),
(700096, 100096, 1, 'StockAdjustmentExcel', 'AI', 10096, '0401D0096', 'PRESSURE TRANSMITTER, 0 - 10 BAR FOR CO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 96, 'A'),
(700097, 100097, 1, 'StockAdjustmentExcel', 'AI', 10097, '0426A0254', 'PERISTALTIC PUMP / 2 /12000 ML / H', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 97, 'A'),
(700098, 100098, 1, 'StockAdjustmentExcel', 'AI', 10098, '0426D0048', 'CONDENSATE MONITOR,MAT.PVC,CONNECTION-', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 98, 'A'),
(700099, 100099, 1, 'StockAdjustmentExcel', 'AI', 10099, '0435a0004', 'BAR SOAP', 'Toolkit Store', '', '', '', 'NOS', 500, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 99, 'A'),
(700100, 100100, 1, 'StockAdjustmentExcel', 'AI', 10100, '0439A0074', 'HYDRAULIC OPERATED HAND PALLET TROLLY', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 100, 'A'),
(700101, 100101, 1, 'StockAdjustmentExcel', 'AI', 10101, '0445A0128', '1.5 SQMM GREY CONTROL CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 101, 'A'),
(700102, 100102, 1, 'StockAdjustmentExcel', 'AI', 10102, '0447A0856', '3Cx10 sq. mm 1.1 KV XLPE AL CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 102, 'A'),
(700103, 100103, 1, 'StockAdjustmentExcel', 'AI', 10103, '0447A0859', '3Cx70 sq. mm 1.1 KV XLPE AL CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 103, 'A'),
(700104, 100104, 1, 'StockAdjustmentExcel', 'AI', 10104, '0447A0897', '3C X 300SQMM 1.1KV ALU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 104, 'A'),
(700105, 100105, 1, 'StockAdjustmentExcel', 'AI', 10105, '0449A0018', 'CABLES,CONTROL FOR FIXED WIRING', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 105, 'A'),
(700106, 100106, 1, 'StockAdjustmentExcel', 'AI', 10106, '0449A0126', 'SINGLE CORE COPPER FLEXIBLE CABLE,1.5SQ', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 106, 'A'),
(700107, 100107, 1, 'StockAdjustmentExcel', 'AI', 10107, '0449A0381', 'CNTRL CABLE 2.5X4C 1KV CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 107, 'A'),
(700108, 100108, 1, 'StockAdjustmentExcel', 'AI', 10108, '0449A0381', 'CTRL CABLE,2.5X4CX1KV,CU,HRE,HRE SH,ARM', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 108, 'A'),
(700109, 100109, 1, 'StockAdjustmentExcel', 'AI', 10109, '0449A0384', 'CTRL CBL,1KV, CU,2.5X4C,SIL,GLS BRAID', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 109, 'A'),
(700110, 100110, 1, 'StockAdjustmentExcel', 'AI', 10110, '0449A0832', '24CX1.5 SQMM 1.1KVXLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 110, 'A'),
(700111, 100111, 1, 'StockAdjustmentExcel', 'AI', 10111, '0449A0834', '16Cx1.5sq. mm 1.1 KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 111, 'A'),
(700112, 100112, 1, 'StockAdjustmentExcel', 'AI', 10112, '0449A0838', '7Cx1.5 SQ.MM 1.1KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 112, 'A'),
(700113, 100113, 1, 'StockAdjustmentExcel', 'AI', 10113, '0449A0840', '4Cx2.5sq. mm 1.1 KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 113, 'A'),
(700114, 100114, 1, 'StockAdjustmentExcel', 'AI', 10114, '0449A0841', '4Cx1.5sq. mm 1.1 KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 114, 'A'),
(700115, 100115, 1, 'StockAdjustmentExcel', 'AI', 10115, '0449A0842', '3Cx2.5 SQ.MM 1.1KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 115, 'A'),
(700116, 100116, 1, 'StockAdjustmentExcel', 'AI', 10116, '0449A0842', '3Cx2.5sq. mm 1.1 KV XLPE AL CABLE', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 116, 'A'),
(700117, 100117, 1, 'StockAdjustmentExcel', 'AI', 10117, '0449A0843', '3Cx1.5sq. mm 1.1 KV XLPE CU CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 117, 'A'),
(700118, 100118, 1, 'StockAdjustmentExcel', 'AI', 10118, '0451B0027', 'HYD.HOSE ASSLY SWAGED   4MM    1/4BSP', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 118, 'A'),
(700119, 100119, 1, 'StockAdjustmentExcel', 'AI', 10119, '0453A0049', 'CABLE FOR CABLE REELING DRUM,70 SQ.MM.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 119, 'A'),
(700120, 100120, 1, 'StockAdjustmentExcel', 'AI', 10120, '0453A0192', 'FLEXIBLE HT CABLE FOR 6.6KV', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 120, 'A'),
(700121, 100121, 1, 'StockAdjustmentExcel', 'AI', 10121, '0470A0610', 'PAD Locking Kit for E Stop switch', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 121, 'A'),
(700122, 100122, 1, 'StockAdjustmentExcel', 'AI', 10122, '0479A0059', 'CTS 1500A CT & TOCB ABB DRIVE', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 122, 'A'),
(700123, 100123, 1, 'StockAdjustmentExcel', 'AI', 10123, '0485A0256', '\"ELECTRONIC DIGITAL MOTOR PROTECTION REL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 123, 'A'),
(700124, 100124, 1, 'StockAdjustmentExcel', 'AI', 10124, '0485A0396', 'ELECTRONIC OVERCURRENT RELAY EOCR 3DM60', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 124, 'A'),
(700125, 100125, 1, 'StockAdjustmentExcel', 'AI', 10125, '0485A0455', 'MOELLER DC CONTROL RELAY 24VDC 2NO 2NC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 125, 'A'),
(700126, 100126, 1, 'StockAdjustmentExcel', 'AI', 10126, '0485A0456', 'MOELLER AC CONTROL RELAY 110VAC 2NO+2NC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 126, 'A'),
(700127, 100127, 1, 'StockAdjustmentExcel', 'AI', 10127, '0485A0689', 'BOCR  - 3 DE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 127, 'A'),
(700128, 100128, 1, 'StockAdjustmentExcel', 'AI', 10128, '0485A1038', '0.5-60A SAMWHA EOCR-3DM2WRDUW', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 128, 'A'),
(700129, 100129, 1, 'StockAdjustmentExcel', 'AI', 10129, '0485A1040', '0.5-60A EOCR Type FMZ2WRDUW with E/F', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 129, 'A'),
(700130, 100130, 1, 'StockAdjustmentExcel', 'AI', 10130, '0486A2447', '7.5KW Motor for Hoist', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 130, 'A'),
(700131, 100131, 1, 'StockAdjustmentExcel', 'AI', 10131, '0486A4060', 'SPL MOTR;SCIM,SEW EURO DRIVE,4 KW', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 131, 'A'),
(700132, 100132, 1, 'StockAdjustmentExcel', 'AI', 10132, '0517A0072', 'SWITCH,PROXIMITY - NO TYPE', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 132, 'A'),
(700133, 100133, 1, 'StockAdjustmentExcel', 'AI', 10133, '0530A0112', 'STRIPPEX HT TAPE HIGH TEMP. TAPE 25MMX0.', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 133, 'A'),
(700134, 100134, 1, 'StockAdjustmentExcel', 'AI', 10134, '0530A0139', 'NO FIRE A - 18 IN 1 LTR.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 134, 'A'),
(700135, 100135, 1, 'StockAdjustmentExcel', 'AI', 10135, '0530A0161', 'SILICO SEAL : ( 7.25 OZ PACK)', 'Toolkit Store', '', '', '', 'BOT', 15, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 135, 'A'),
(700136, 100136, 1, 'StockAdjustmentExcel', 'AI', 10136, '0530B0053', 'PRISM 406 for O-ring', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 136, 'A'),
(700137, 100137, 1, 'StockAdjustmentExcel', 'AI', 10137, '0535A0115', '\"THERMOMETER BULB DIA 6MM, 8MM, 10MM, 12', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 137, 'A'),
(700138, 100138, 1, 'StockAdjustmentExcel', 'AI', 10138, '0535A0474', 'TRUE-RMS METER FOR PRECISE MEASUREMENT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 138, 'A'),
(700139, 100139, 1, 'StockAdjustmentExcel', 'AI', 10139, '0546A1974', 'Drill M/C IFM  M 12 connector(EVC009)', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 139, 'A'),
(700140, 100140, 1, 'StockAdjustmentExcel', 'AI', 10140, '0546G0037', 'SS TYPE 5 PIN PLUG 30A 500V FOR TEMP.MEA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 140, 'A'),
(700141, 100141, 1, 'StockAdjustmentExcel', 'AI', 10141, '0546P0073', 'INSTRUMENTATION SPARES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 141, 'A'),
(700142, 100142, 1, 'StockAdjustmentExcel', 'AI', 10142, '0556A0144', '16 SQ MM,CU FLATE SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 142, 'A'),
(700143, 100143, 1, 'StockAdjustmentExcel', 'AI', 10143, '0556A0145', '25 SQ MM,CU FLATE SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 143, 'A'),
(700144, 100144, 1, 'StockAdjustmentExcel', 'AI', 10144, '0556A0146', '50 SQ MM,CU FLATE SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 144, 'A'),
(700145, 100145, 1, 'StockAdjustmentExcel', 'AI', 10145, '0556A0995', 'COPPER SOCKET  (XLPE)', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 145, 'A'),
(700146, 100146, 1, 'StockAdjustmentExcel', 'AI', 10146, '0556A0996', 'COPPER SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 146, 'A'),
(700147, 100147, 1, 'StockAdjustmentExcel', 'AI', 10147, '0556A1023', 'COPPER SOCKET HEAVY DUTY 50 SQ.MM.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 147, 'A'),
(700148, 100148, 1, 'StockAdjustmentExcel', 'AI', 10148, '0556A1035', 'SOCKET FOR CABLE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 148, 'A'),
(700149, 100149, 1, 'StockAdjustmentExcel', 'AI', 10149, '0556A1036', 'PIN SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 149, 'A'),
(700150, 100150, 1, 'StockAdjustmentExcel', 'AI', 10150, '0556A1038', 'PIN SOCKET', 'Toolkit Store', '', '', '', 'NOS', 79, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 150, 'A'),
(700151, 100151, 1, 'StockAdjustmentExcel', 'AI', 10151, '0556A1045', 'RING SOCKET', 'Toolkit Store', '', '', '', 'NOS', 98, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 151, 'A'),
(700152, 100152, 1, 'StockAdjustmentExcel', 'AI', 10152, '0556A1047', 'RING SOCKET', 'Toolkit Store', '', '', '', 'NOS', 70, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 152, 'A'),
(700153, 100153, 1, 'StockAdjustmentExcel', 'AI', 10153, '0556A1049', 'RING SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 153, 'A'),
(700154, 100154, 1, 'StockAdjustmentExcel', 'AI', 10154, '0556A1069', 'COPPER SOCKET (XLPE) 70MM.SQ.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 154, 'A'),
(700155, 100155, 1, 'StockAdjustmentExcel', 'AI', 10155, '0556A1070', 'CU.SOCKET 95 MM.SQ.', 'Toolkit Store', '', '', '', 'NOS', 186, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 155, 'A'),
(700156, 100156, 1, 'StockAdjustmentExcel', 'AI', 10156, '0556A1071', 'CU. RING SOCKET50 MM.SQ.', 'Toolkit Store', '', '', '', 'NOS', 49, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 156, 'A'),
(700157, 100157, 1, 'StockAdjustmentExcel', 'AI', 10157, '0556A1073', 'CU.RING SOCKET 70 MM.SQ.', 'Toolkit Store', '', '', '', 'NOS', 45, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 157, 'A'),
(700158, 100158, 1, 'StockAdjustmentExcel', 'AI', 10158, '0565B0058', 'BRAKE SHOE COMPT.WITH LINING FOR 8\"DIA', 'Toolkit Store', '', '', '', 'PAA', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 158, 'A'),
(700159, 100159, 1, 'StockAdjustmentExcel', 'AI', 10159, '0579A1264', 'Polyuretane foam (PUF) seal', 'Toolkit Store', '', '', '', 'ML', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 159, 'A'),
(700160, 100160, 1, 'StockAdjustmentExcel', 'AI', 10160, '0579A1287', 'Solvent based cleaner Light duty Spray', 'Toolkit Store', '', '', '', 'ml', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 160, 'A'),
(700161, 100161, 1, 'StockAdjustmentExcel', 'AI', 10161, '0622A0898', 'PNEUMATIC HOSE 12.07.X 5 METER 20 KG.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 161, 'A'),
(700162, 100162, 1, 'StockAdjustmentExcel', 'AI', 10162, '0633A0104', 'CABLE TIE 100X2.5', 'Toolkit Store', '', '', '', 'NOS', 4600, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 162, 'A'),
(700163, 100163, 1, 'StockAdjustmentExcel', 'AI', 10163, '0633A0105', 'TIE 188X4.8', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 163, 'A'),
(700164, 100164, 1, 'StockAdjustmentExcel', 'AI', 10164, '0633A0106', 'CABLE TIE 370X4.8', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 164, 'A'),
(700165, 100165, 1, 'StockAdjustmentExcel', 'AI', 10165, '0666A0079', 'TRANSFORMER OIL,E.H.V,AS PER IS:335,AL', 'Toolkit Store', '', '', '', 'LTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 165, 'A'),
(700166, 100166, 1, 'StockAdjustmentExcel', 'AI', 10166, '0782A0938', 'M.I.CABLE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 166, 'A'),
(700167, 100167, 1, 'StockAdjustmentExcel', 'AI', 10167, '0782A0939', 'M.I.CABLE, 4 CORE CELOX, TYPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 167, 'A'),
(700168, 100168, 1, 'StockAdjustmentExcel', 'AI', 10168, '0782A1332', 'M.I.CABLE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 168, 'A'),
(700169, 100169, 1, 'StockAdjustmentExcel', 'AI', 10169, '0782A1348', 'M.I.CABLE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 169, 'A'),
(700170, 100170, 1, 'StockAdjustmentExcel', 'AI', 10170, '0814A0005', 'BRAKE SHOE WITH LINING FOR 10\" DIA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 170, 'A'),
(700171, 100171, 1, 'StockAdjustmentExcel', 'AI', 10171, '0814A0006', 'BRAKE SHOE WITH LINING FOR 13\" DIA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 171, 'A'),
(700172, 100172, 1, 'StockAdjustmentExcel', 'AI', 10172, '0829A0093', 'HAND LEVER OPERATED GREASE GUN', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 172, 'A'),
(700173, 100173, 1, 'StockAdjustmentExcel', 'AI', 10173, '0829A0095', 'VOLUME PUMP 10 KG FOR MANUAL LUBRICATION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 173, 'A'),
(700174, 100174, 1, 'StockAdjustmentExcel', 'AI', 10174, '0843A0003', 'REGULATOR FOR CEILING FAN', 'Toolkit Store', '', '', '', 'NOS', 16, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 174, 'A'),
(700175, 100175, 1, 'StockAdjustmentExcel', 'AI', 10175, '0850A0012', 'PLICA CONDUIT 3/4\"LEAD COATED,HEAT & C', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 175, 'A'),
(700176, 100176, 1, 'StockAdjustmentExcel', 'AI', 10176, '0850A0013', 'PLICA CONDUIT 1\" LEAD COATED,HEAT & CO', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 176, 'A'),
(700177, 100177, 1, 'StockAdjustmentExcel', 'AI', 10177, '0853A0082', 'SWITCH & CIRCUIT BREAKER ACCESSORIES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 177, 'A'),
(700178, 100178, 1, 'StockAdjustmentExcel', 'AI', 10178, '0853A0388', '2 32AMPS HRC FUSE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 178, 'A'),
(700179, 100179, 1, 'StockAdjustmentExcel', 'AI', 10179, '0853A0468', '2 HRC FUSE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 179, 'A'),
(700180, 100180, 1, 'StockAdjustmentExcel', 'AI', 10180, '0853A0471', 'ACTUATOR NORMAL(RED)', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 180, 'A'),
(700181, 100181, 1, 'StockAdjustmentExcel', 'AI', 10181, '0853A0496', 'COIL FOR 3TF56 CONTACTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 181, 'A'),
(700182, 100182, 1, 'StockAdjustmentExcel', 'AI', 10182, '0853a0526', 'ACTUATOR,1NO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 182, 'A'),
(700183, 100183, 1, 'StockAdjustmentExcel', 'AI', 10183, '0853A0527', 'SIEMENS CONTACTOR,110VAC,3TF3400-OAFO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 183, 'A'),
(700184, 100184, 1, 'StockAdjustmentExcel', 'AI', 10184, '0853A0542', 'AUX.BLOCK WITH 2NO+2NC', 'Toolkit Store', '', '', '', 'NOS', 8, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 184, 'A'),
(700185, 100185, 1, 'StockAdjustmentExcel', 'AI', 10185, '0853A0594', ' PENDANT CONTROL STATION, MAKE: TELEMECA', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 185, 'A'),
(700186, 100186, 1, 'StockAdjustmentExcel', 'AI', 10186, '0853A0684', '5PAK 100 US WITH 2N/O+2NC WITH 110V AC C', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 186, 'A'),
(700187, 100187, 1, 'StockAdjustmentExcel', 'AI', 10187, '0853O0028', 'SILICA GEL SOLID GLOSSY RTS 741', 'Toolkit Store', '', '', '', 'KG', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 187, 'A'),
(700188, 100188, 1, 'StockAdjustmentExcel', 'AI', 10188, '0858A0636', 'LOAD CELL 25 TON', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 188, 'A'),
(700189, 100189, 1, 'StockAdjustmentExcel', 'AI', 10189, '0870A0746', 'HP laserjet 305A Printer cartridge', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 189, 'A'),
(700190, 100190, 1, 'StockAdjustmentExcel', 'AI', 10190, '0870A0747', 'HP laserjet 305A Printer cartridge.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 190, 'A'),
(700191, 100191, 1, 'StockAdjustmentExcel', 'AI', 10191, '0870A0748', 'HP laserjet 305A Printer cartridge', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 191, 'A'),
(700192, 100192, 1, 'StockAdjustmentExcel', 'AI', 10192, '0870A0749', ' HP laserjet 305A Printer cartridge', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 192, 'A'),
(700193, 100193, 1, 'StockAdjustmentExcel', 'AI', 10193, '0877A0124', 'HRC FUSE SIZE 0,2AMPS', 'Toolkit Store', '', '', '', 'NOS', 30, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 193, 'A'),
(700194, 100194, 1, 'StockAdjustmentExcel', 'AI', 10194, '0877A0330', 'HRC FUSE', 'Toolkit Store', '', '', '', 'NOS', 224, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 194, 'A'),
(700195, 100195, 1, 'StockAdjustmentExcel', 'AI', 10195, '0877A0332', 'HRC FUSE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 195, 'A'),
(700196, 100196, 1, 'StockAdjustmentExcel', 'AI', 10196, '0877A0333', 'HRC FUSE SIZE 0.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 196, 'A'),
(700197, 100197, 1, 'StockAdjustmentExcel', 'AI', 10197, '0877A0336', 'HRC FUSE SIZE 0.', 'Toolkit Store', '', '', '', 'NOS', 46, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 197, 'A'),
(700198, 100198, 1, 'StockAdjustmentExcel', 'AI', 10198, '0877A0342', 'HRC FUSE SIZE 1.', 'Toolkit Store', '', '', '', 'NOS', 47, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 198, 'A'),
(700199, 100199, 1, 'StockAdjustmentExcel', 'AI', 10199, '0877A0343', 'HRC FUSE SIZE 1.', 'Toolkit Store', '', '', '', 'NOS', 31, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 199, 'A'),
(700200, 100200, 1, 'StockAdjustmentExcel', 'AI', 10200, '0877A0344', 'HRC FUSE SIZE 1.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 200, 'A'),
(700201, 100201, 1, 'StockAdjustmentExcel', 'AI', 10201, '0877A0463', '16 A  HRC FUSE BS TYPE', 'Toolkit Store', '', '', '', 'NOS', 33, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 201, 'A'),
(700202, 100202, 1, 'StockAdjustmentExcel', 'AI', 10202, '0877A0500', 'HRC FUSE 2 AMPERES', 'Toolkit Store', '', '', '', 'NOS', 60, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 202, 'A'),
(700203, 100203, 1, 'StockAdjustmentExcel', 'AI', 10203, '0877A0737', 'HF FUSE 10A,SF90148,L&T', 'Toolkit Store', '', '', '', 'NOS', 120, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 203, 'A'),
(700204, 100204, 1, 'StockAdjustmentExcel', 'AI', 10204, '0877A0738', 'HF FUSE 20 AMP SF90151 L&T', 'Toolkit Store', '', '', '', 'NOS', 18, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 204, 'A'),
(700205, 100205, 1, 'StockAdjustmentExcel', 'AI', 10205, '0877A0739', 'HF FUSE 25A,SF90152,L&T', 'Toolkit Store', '', '', '', 'NOS', 30, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 205, 'A'),
(700206, 100206, 1, 'StockAdjustmentExcel', 'AI', 10206, '0877B0037', 'FUSE', 'Toolkit Store', '', '', '', 'NOS', 50, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 206, 'A');
INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(700207, 100207, 1, 'StockAdjustmentExcel', 'AI', 10207, '0877B0041', 'FUSE', 'Toolkit Store', '', '', '', 'NOS', 35, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 207, 'A'),
(700208, 100208, 1, 'StockAdjustmentExcel', 'AI', 10208, '0877B0043', 'FUSE', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 208, 'A'),
(700209, 100209, 1, 'StockAdjustmentExcel', 'AI', 10209, '0877B0046', 'FUSE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 209, 'A'),
(700210, 100210, 1, 'StockAdjustmentExcel', 'AI', 10210, '0877B0049', 'FUSE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 210, 'A'),
(700211, 100211, 1, 'StockAdjustmentExcel', 'AI', 10211, '0910A1488', 'INPUT SHAFT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 211, 'A'),
(700212, 100212, 1, 'StockAdjustmentExcel', 'AI', 10212, '0910A2026', 'LT DRIVE OUTPUT SHAFT', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 212, 'A'),
(700213, 100213, 1, 'StockAdjustmentExcel', 'AI', 10213, '0929A0011', 'SEALANT TAPE  12MT. PER ROLL', 'Toolkit Store', '', '', '', 'MTR', 168, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 213, 'A'),
(700214, 100214, 1, 'StockAdjustmentExcel', 'AI', 10214, '0936A0107', 'PLUG & SOCKET BOARD 220V 20A SPN', 'Toolkit Store', '', '', '', 'NOS', 7, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 214, 'A'),
(700215, 100215, 1, 'StockAdjustmentExcel', 'AI', 10215, '0936A0207', 'MOUNTING CHANNEL FOR ELEMEX,MCB.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 215, 'A'),
(700216, 100216, 1, 'StockAdjustmentExcel', 'AI', 10216, '0936A0279', '63 AMP DS PLUG AND SOCKET ,BOX MOUNTED', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 216, 'A'),
(700217, 100217, 1, 'StockAdjustmentExcel', 'AI', 10217, '0937A0039', 'CONTROL CABLE FOR INSTRUMENTATION-4 PAIR  0.8MM ', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 217, 'A'),
(700218, 100218, 1, 'StockAdjustmentExcel', 'AI', 10218, '0940A0015', 'CABLES FOR FESTOONING(4 SQ.MM.,1100 VOLT,4 CORE,FLEXIBLE)', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 218, 'A'),
(700219, 100219, 1, 'StockAdjustmentExcel', 'AI', 10219, '0940A0056', 'FESTOONING CABLE,10X3C,1KV,CU,EPR,CSP SH', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 219, 'A'),
(700220, 100220, 1, 'StockAdjustmentExcel', 'AI', 10220, '0940A0057', 'FESTOONING CABLE,6X3CX1KV,CU,EPR,CSP SH', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 220, 'A'),
(700221, 100221, 1, 'StockAdjustmentExcel', 'AI', 10221, '0940A0102', 'FESTOON CABLE,SCREENED, 4C X 2.5 SQ.MM', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 221, 'A'),
(700222, 100222, 1, 'StockAdjustmentExcel', 'AI', 10222, '0940A0103', 'CABLE,FLEX,Cu,PVC,2.5SQ.,MM X 4C, LAPP', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 222, 'A'),
(700223, 100223, 1, 'StockAdjustmentExcel', 'AI', 10223, '0940A0103', 'FLEX CABLE CU PVC 4CX2.5SQMM LAPP CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 223, 'A'),
(700224, 100224, 1, 'StockAdjustmentExcel', 'AI', 10224, '0954A0007', 'ELECTRODE 6013 MILD STEEL 4 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 224, 'A'),
(700225, 100225, 1, 'StockAdjustmentExcel', 'AI', 10225, '0954A0008', 'WELDING ELECT MILD STEEL 3.15 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 225, 'A'),
(700226, 100226, 1, 'StockAdjustmentExcel', 'AI', 10226, '0954A0009', 'WELDING ELECT MILD STEEL 2.5 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 226, 'A'),
(700227, 100227, 1, 'StockAdjustmentExcel', 'AI', 10227, '0954A0011', 'ELECTRODE 7018 LOW HYDROGEN 4 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 227, 'A'),
(700228, 100228, 1, 'StockAdjustmentExcel', 'AI', 10228, '0954A0012', 'WELDING ELECT LOW HYDROGEN 3.15 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 228, 'A'),
(700229, 100229, 1, 'StockAdjustmentExcel', 'AI', 10229, '0954A0013', 'ELECTRODE,AWS 7018,MEDIUM CARBON,2.5 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 229, 'A'),
(700230, 100230, 1, 'StockAdjustmentExcel', 'AI', 10230, '0957A0074', 'DURACELL PLUS AAA ALKALINE 1.5V BATTERY', 'Toolkit Store', '', '', '', 'NOS', 14, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 230, 'A'),
(700231, 100231, 1, 'StockAdjustmentExcel', 'AI', 10231, '0957A0119', 'SIZE AA PENCIL CELL,1.5V', 'Toolkit Store', '', '', '', 'NOS', 297, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 231, 'A'),
(700232, 100232, 1, 'StockAdjustmentExcel', 'AI', 10232, '0958A0848', 'DURACELL PLUS, AA SIZE, 1.5 V.', 'Toolkit Store', '', '', '', 'NOS', 105, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 232, 'A'),
(700233, 100233, 1, 'StockAdjustmentExcel', 'AI', 10233, '0959A0295', 'BATTERY GRADE SULPHURIC ACID', 'Toolkit Store', '', '', '', 'LTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 233, 'A'),
(700234, 100234, 1, 'StockAdjustmentExcel', 'AI', 10234, '0960a0094', 'BATTERY CHARGER, 2 NOS FLOAT CUM BOOST', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 234, 'A'),
(700235, 100235, 1, 'StockAdjustmentExcel', 'AI', 10235, '0983A0176', 'AXIAL FLOW FAN', 'Toolkit Store', '', '', '', 'nOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 235, 'A'),
(700236, 100236, 1, 'StockAdjustmentExcel', 'AI', 10236, '0996A0058', 'FR Jacket E3 grade-Small', 'Toolkit Store', '', '', '', 'NOS', 18, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 236, 'A'),
(700237, 100237, 1, 'StockAdjustmentExcel', 'AI', 10237, '0996A0059', 'FR Jacket E3 grade- Medium', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 237, 'A'),
(700238, 100238, 1, 'StockAdjustmentExcel', 'AI', 10238, '0996A0060', 'FR Jacket E3 grade- Large', 'Toolkit Store', '', '', '', 'NOS', 19, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 238, 'A'),
(700239, 100239, 1, 'StockAdjustmentExcel', 'AI', 10239, '0996A0061', 'FR Jacket E3 grade- Ex Large', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 239, 'A'),
(700240, 100240, 1, 'StockAdjustmentExcel', 'AI', 10240, '0996A0062', 'FR Trouser E3 grade- Small', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 240, 'A'),
(700241, 100241, 1, 'StockAdjustmentExcel', 'AI', 10241, '0996A0063', 'FR Trouser E3 grade- Medium', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 241, 'A'),
(700242, 100242, 1, 'StockAdjustmentExcel', 'AI', 10242, '0996A0064', 'FR Trouser E3 grade-Large', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 242, 'A'),
(700243, 100243, 1, 'StockAdjustmentExcel', 'AI', 10243, '0996A0065', 'FR Trouser E3 grade- Ex Large', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 243, 'A'),
(700244, 100244, 1, 'StockAdjustmentExcel', 'AI', 10244, '0999A0333', '150 WATT METAL HALIDE LAMP', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 244, 'A'),
(700245, 100245, 1, 'StockAdjustmentExcel', 'AI', 10245, '1041A4636', 'SP4 570A 1400V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 245, 'A'),
(700246, 100246, 1, 'StockAdjustmentExcel', 'AI', 10246, '1041A4723', 'RCNA-01 CONTROL NET ADAPTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 246, 'A'),
(700247, 100247, 1, 'StockAdjustmentExcel', 'AI', 10247, '1041A5472', 'Analogue I/O 16 chan', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 247, 'A'),
(700248, 100248, 1, 'StockAdjustmentExcel', 'AI', 10248, '1041A5482', 'DO module,8 channel, 24V DC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 248, 'A'),
(700249, 100249, 1, 'StockAdjustmentExcel', 'AI', 10249, '1047A1419', 'BUS CONNECTOR FOR PROFIBUS PG 12 MBIT/S', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 249, 'A'),
(700250, 100250, 1, 'StockAdjustmentExcel', 'AI', 10250, '1048A0216', 'RIGHT END CAP TERMINAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:34', 'usertool', 20001, 250, 'A'),
(700251, 100251, 1, 'StockAdjustmentExcel', 'AI', 10251, '1072A0555', 'USB 3-I THRUSTER DISC BRAKE 400x30-50/6', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 251, 'A'),
(700252, 100252, 1, 'StockAdjustmentExcel', 'AI', 10252, '1072A1160', '19 inch brake liner', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 252, 'A'),
(700253, 100253, 1, 'StockAdjustmentExcel', 'AI', 10253, '1106A0005', '\"LIGHTING CONNECTOR       ,SIZE : 0.5  T', 'Toolkit Store', '', '', '', 'NOS', 1102, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 253, 'A'),
(700254, 100254, 1, 'StockAdjustmentExcel', 'AI', 10254, '1106A0038', '0.08 TO 4 MM SQUARE SCREWLESS TERMINAL B', 'Toolkit Store', '', '', '', 'NOS', 700, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 254, 'A'),
(700255, 100255, 1, 'StockAdjustmentExcel', 'AI', 10255, '1138A0024', 'LIGHTING TRANSFORMER,25 KVA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 255, 'A'),
(700256, 100256, 1, 'StockAdjustmentExcel', 'AI', 10256, '1142A0259', 'MNX400 CONTACTOR CS94144', 'Toolkit Store', '', '', '', 'NOS', 7, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 256, 'A'),
(700257, 100257, 1, 'StockAdjustmentExcel', 'AI', 10257, '1142A0265', 'MNX110 CONTACTOR CS94137', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 257, 'A'),
(700258, 100258, 1, 'StockAdjustmentExcel', 'AI', 10258, '1156A0083', 'XD2PA22 ONE NOTCH 2 DIRECTION JOYSTICK', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 258, 'A'),
(700259, 100259, 1, 'StockAdjustmentExcel', 'AI', 10259, '1304A0613', '48 Port Switch', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 259, 'A'),
(700260, 100260, 1, 'StockAdjustmentExcel', 'AI', 10260, '1306A0288', 'S.Sleeve,40.0 mm shaft X 9.91 mm wide', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 260, 'A'),
(700261, 100261, 1, 'StockAdjustmentExcel', 'AI', 10261, '1306A0329', 'S.Sleeve,110.0 mm shaft X 12.93 mm wide', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 261, 'A'),
(700262, 100262, 1, 'StockAdjustmentExcel', 'AI', 10262, '1586A1068', 'Control Net Redundant Bridge Module', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 262, 'A'),
(700263, 100263, 1, 'StockAdjustmentExcel', 'AI', 10263, '1586A1069', 'EhterNet/IP Communication Bridge Module', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 263, 'A'),
(700264, 100264, 1, 'StockAdjustmentExcel', 'AI', 10264, '1586A1224', '24V DC, 8A POWER SUPPLY MODULE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 264, 'A'),
(700265, 100265, 1, 'StockAdjustmentExcel', 'AI', 10265, '1586A1251', 'PROFIBUS CONNECTOR WITHOUT PG:', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 265, 'A'),
(700266, 100266, 1, 'StockAdjustmentExcel', 'AI', 10266, '1586A1533', 'Redundancy Module', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 266, 'A'),
(700267, 100267, 1, 'StockAdjustmentExcel', 'AI', 10267, '1615A0422', 'RG-6 Co-axial Cable.(Video Cable)', 'Toolkit Store', '', '', '', 'mtr', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 267, 'A'),
(700268, 100268, 1, 'StockAdjustmentExcel', 'AI', 10268, '1877A0048', 'CV6 COIL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 268, 'A'),
(700269, 100269, 1, 'StockAdjustmentExcel', 'AI', 10269, '1877A0324', 'GLAND PACKING-M/C-52NE7581', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 269, 'A'),
(700270, 100270, 1, 'StockAdjustmentExcel', 'AI', 10270, '1877A1181', 'OIL LEAKAGE KIT -(Common New)', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 270, 'A'),
(700271, 100271, 1, 'StockAdjustmentExcel', 'AI', 10271, '1889A1390', 'POWER SUPPLY MODULE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 271, 'A'),
(700272, 100272, 1, 'StockAdjustmentExcel', 'AI', 10272, '1889A1393', 'DIGITAL INPUT MODULE 32 DI', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 272, 'A'),
(700273, 100273, 1, 'StockAdjustmentExcel', 'AI', 10273, '1889A1396', 'BUSTERMINAL FOR PROFIBUS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 273, 'A'),
(700274, 100274, 1, 'StockAdjustmentExcel', 'AI', 10274, '1889A1407', 'RELAY COUPLE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 274, 'A'),
(700275, 100275, 1, 'StockAdjustmentExcel', 'AI', 10275, '1889A1409', 'VALVE CONNECTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 275, 'A'),
(700276, 100276, 1, 'StockAdjustmentExcel', 'AI', 10276, '1889A1413', 'POWER SUPPLY DC - SITOP', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 276, 'A'),
(700277, 100277, 1, 'StockAdjustmentExcel', 'AI', 10277, '1889A1416', 'MAINS FILTER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 277, 'A'),
(700278, 100278, 1, 'StockAdjustmentExcel', 'AI', 10278, '1889A1419', 'IND. PROXIMITY SWITCH', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 278, 'A'),
(700279, 100279, 1, 'StockAdjustmentExcel', 'AI', 10279, '2442A0022', 'PORTABLE HAND BLOWER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 279, 'A'),
(700280, 100280, 1, 'StockAdjustmentExcel', 'AI', 10280, '2746A0072', '4 core trailing cable for B-type T/C', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 280, 'A'),
(700281, 100281, 1, 'StockAdjustmentExcel', 'AI', 10281, '2746A0112', 'MODBUS CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 281, 'A'),
(700282, 100282, 1, 'StockAdjustmentExcel', 'AI', 10282, '3178A0113', 'SIMATIC NET, PROFIBUS OLM/G12 V4.0', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 282, 'A'),
(700283, 100283, 1, 'StockAdjustmentExcel', 'AI', 10283, '3178A0132', 'EhterNet/IP Communication Bridge Module', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 283, 'A'),
(700284, 100284, 1, 'StockAdjustmentExcel', 'AI', 10284, '3285A0023', 'CABIN FAN', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 284, 'A'),
(700285, 100285, 1, 'StockAdjustmentExcel', 'AI', 10285, '5010A0252', 'SPHRICAL ROLLR BRG,22230 CC/W33,STRAIGHT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 285, 'A'),
(700286, 100286, 1, 'StockAdjustmentExcel', 'AI', 10286, '5010A0332', 'SPHRICAL ROLLR BRG,23136 CCW33,STRAIGHT,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 286, 'A'),
(700287, 100287, 1, 'StockAdjustmentExcel', 'AI', 10287, '5010A0429', 'SPHRICAL ROLLR BRG;22334CCW33,STRAIGHT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 287, 'A'),
(700288, 100288, 1, 'StockAdjustmentExcel', 'AI', 10288, '5010A0588', '24124CC/W33,STRAIGHT,120MM,200MM,80MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 288, 'A'),
(700289, 100289, 1, 'StockAdjustmentExcel', 'AI', 10289, '5013A0268', 'TAPER ROLLR BRG;33209,45MM,85MM,32MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 289, 'A'),
(700290, 100290, 1, 'StockAdjustmentExcel', 'AI', 10290, '5013A0322', 'TAPER ROLLR BRG', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 290, 'A'),
(700291, 100291, 1, 'StockAdjustmentExcel', 'AI', 10291, '5014A0090', 'EL SWCH;32A,1,DP SWITCH,HDP,230-250V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 291, 'A'),
(700292, 100292, 1, 'StockAdjustmentExcel', 'AI', 10292, '5036A0868', 'BEARING;SL 182928 ,NORMAL ,STEEL ,140 MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 292, 'A'),
(700293, 100293, 1, 'StockAdjustmentExcel', 'AI', 10293, '5176A0052', 'WLKY TLKY SPR;PTT KEYPAD,MOTOROLA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 293, 'A'),
(700294, 100294, 1, 'StockAdjustmentExcel', 'AI', 10294, '5176A0091', 'BATTERY ,KENWOOD ,KNB 57L ,WALKIE TALKIE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 294, 'A'),
(700295, 100295, 1, 'StockAdjustmentExcel', 'AI', 10295, '5189A0018', 'ELECTRONIC INST,TESTNG & MSRNG,ELECTRIC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 295, 'A'),
(700296, 100296, 1, 'StockAdjustmentExcel', 'AI', 10296, '5189A0089', 'EL T&M INST', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 296, 'A'),
(700297, 100297, 1, 'StockAdjustmentExcel', 'AI', 10297, '5276A0028', 'SFTWR;KEPWARE,KEPWARE MODBUS OPC SUITE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 297, 'A'),
(700298, 100298, 1, 'StockAdjustmentExcel', 'AI', 10298, '5288A0049', 'SFTY SHOE;10IN,BLACK', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 298, 'A'),
(700299, 100299, 1, 'StockAdjustmentExcel', 'AI', 10299, '5288A0050', 'SFTY SHOE;9,BLACK,INSULATED STEEL TOE', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 299, 'A'),
(700300, 100300, 1, 'StockAdjustmentExcel', 'AI', 10300, '5288A0055', 'SFTY SHOE;8IN,BLACK,INSULATED STEEL TOE', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 300, 'A'),
(700301, 100301, 1, 'StockAdjustmentExcel', 'AI', 10301, '5288A0056', 'SFTY SHOE;7IN,BLACK,INSULATED STEEL TOE', 'Toolkit Store', '', '', '', 'NOS', 4, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 301, 'A'),
(700302, 100302, 1, 'StockAdjustmentExcel', 'AI', 10302, '5288A0057', 'SFTY SHOE;6IN,BLACK,INSULATED STEEL TOE', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 302, 'A'),
(700303, 100303, 1, 'StockAdjustmentExcel', 'AI', 10303, '5288A0065', 'SFTY SHOE;5IN,BLACK,INSULATED STEEL TOE', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 303, 'A'),
(700304, 100304, 1, 'StockAdjustmentExcel', 'AI', 10304, '5309A1110', 'FRMC OVL ICU SXGA+ ,BARCO NOS,LARGE VIDE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 304, 'A'),
(700305, 100305, 1, 'StockAdjustmentExcel', 'AI', 10305, '5309A1112', 'UN OVL ENGINE Y T3 ,BARCO NOS,LARGE VIDE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 305, 'A'),
(700306, 100306, 1, 'StockAdjustmentExcel', 'AI', 10306, '5309A1452', 'SPEAKERPHONE  ,SENNHEISER  ,LAPTOP  ,HP/', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 306, 'A'),
(700307, 100307, 1, 'StockAdjustmentExcel', 'AI', 10307, '5309A1749', '32\" CURVE TFT ,HP ,DISPLAY MONITOR ,HP ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 307, 'A'),
(700308, 100308, 1, 'StockAdjustmentExcel', 'AI', 10308, '5309A1855', 'WIRELESS BLUETOOTH HEADPHONE  ,BOAT  ,LA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 308, 'A'),
(700309, 100309, 1, 'StockAdjustmentExcel', 'AI', 10309, '5320A0776', 'OIL SEAL;HIGH NITRILE RUBBER,45MM,62MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 309, 'A'),
(700310, 100310, 1, 'StockAdjustmentExcel', 'AI', 10310, '5320A1316', 'OIL SEAL;NBR ,140 MM,170 MM,12 MM,120 Â°C', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 310, 'A'),
(700311, 100311, 1, 'StockAdjustmentExcel', 'AI', 10311, '5322A0042', 'WIRELESS GTWY;ANTENNA ,USIT ,USIT-ASL-10', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 311, 'A'),
(700312, 100312, 1, 'StockAdjustmentExcel', 'AI', 10312, '5322A0067', 'WIRELESS GTWY;RF DATA TRANSMISSION ,PHOE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 312, 'A'),
(700313, 100313, 1, 'StockAdjustmentExcel', 'AI', 10313, '5355A0003', '11KV ELECT INSULATING MAT', 'Toolkit Store', '', '', '', 'ROLL', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 313, 'A'),
(700314, 100314, 1, 'StockAdjustmentExcel', 'AI', 10314, '5362A0028', 'PT;33/v3 KV,110/V3V,1,CAST RESIN,INDOOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 314, 'A'),
(700315, 100315, 1, 'StockAdjustmentExcel', 'AI', 10315, '5378A0005', 'O-RING CORD,NBR,5.7MM,72SHORE A,120Â¬C,NO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 315, 'A'),
(700316, 100316, 1, 'StockAdjustmentExcel', 'AI', 10316, '5387A0001', 'PRSE KNT HND GL;8', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 316, 'A'),
(700317, 100317, 1, 'StockAdjustmentExcel', 'AI', 10317, '5387A0002', 'PRSE KNT HND GL;Knitted hand gloves 12\"', 'Toolkit Store', '', '', '', 'PAA', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 317, 'A'),
(700318, 100318, 1, 'StockAdjustmentExcel', 'AI', 10318, '5434A0068', 'PAINT;PAINTING,ENAMEL,RED,4L TIN', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 318, 'A'),
(700319, 100319, 1, 'StockAdjustmentExcel', 'AI', 10319, '5434A0070', 'PAINT;PAINTING,ENAMEL,GOLDEN YELLOW', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 319, 'A'),
(700320, 100320, 1, 'StockAdjustmentExcel', 'AI', 10320, '5437A0012', 'SWTCH NTWRK;1000MBPS,24NOS', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 320, 'A'),
(700321, 100321, 1, 'StockAdjustmentExcel', 'AI', 10321, '5455A0580', 'HYD. HAND PUMP WITH PRE. GAUGE  ,ENERPAC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 321, 'A'),
(700322, 100322, 1, 'StockAdjustmentExcel', 'AI', 10322, '5483A0040', 'INSLTG TPE;ADHESIVE PVC  ,1.1  KV,GREEN', 'Toolkit Store', '', '', '', 'nOS', 291, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 322, 'A'),
(700323, 100323, 1, 'StockAdjustmentExcel', 'AI', 10323, '5490A0241', 'WEGHNG M/C ACC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 323, 'A'),
(700324, 100324, 1, 'StockAdjustmentExcel', 'AI', 10324, '5495A0160', 'CNTRLR;MASTER CONTROLLER,220VAC,DIGITAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 324, 'A'),
(700325, 100325, 1, 'StockAdjustmentExcel', 'AI', 10325, '5502A0271', 'CPLNG SPR,SPIDER,L225,LOVEJOY,FLEXIBLE,N', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 325, 'A'),
(700326, 100326, 1, 'StockAdjustmentExcel', 'AI', 10326, '5507A0023', 'BRAKE;160MM,ELECTROMAGNETIC,DRUM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 326, 'A'),
(700327, 100327, 1, 'StockAdjustmentExcel', 'AI', 10327, '5507A0038', 'BRAKE;150MM,ELECTROMAGNETIC,DRUM', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 327, 'A'),
(700328, 100328, 1, 'StockAdjustmentExcel', 'AI', 10328, '5508A0110', 'ENCODER;HOLLOW SHAFT INC ENCODER,KUBLER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 328, 'A'),
(700329, 100329, 1, 'StockAdjustmentExcel', 'AI', 10329, '5509A0316', 'MCCB;32A,3,415V,50KA,AC,50HZ,1NO+1NC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 329, 'A'),
(700330, 100330, 1, 'StockAdjustmentExcel', 'AI', 10330, '5512A0090', 'SPR LOAD CEL;SARTORIUS,PR 6201/15N', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 330, 'A'),
(700331, 100331, 1, 'StockAdjustmentExcel', 'AI', 10331, '5513A0010', '7 SEG DSPLY;LED,RED,4,RED,100MM,190MM', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 331, 'A'),
(700332, 100332, 1, 'StockAdjustmentExcel', 'AI', 10332, '5521A0322', 'BRAKE SHOE WITH LINER ,SIBRE ,SIBRE ,TE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 332, 'A'),
(700333, 100333, 1, 'StockAdjustmentExcel', 'AI', 10333, '5523A0094', 'FAN;CABIN,AC,1,230V,WALL,50HZ,400MM,4', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 333, 'A'),
(700334, 100334, 1, 'StockAdjustmentExcel', 'AI', 10334, '5523A0145', 'FAN;HEAVY DUTY AXIAL FLOW FAN ,AC ,SINGL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 334, 'A'),
(700335, 100335, 1, 'StockAdjustmentExcel', 'AI', 10335, '5527A0014', 'FLXBL CNDUIT,2\",PVC,FLEXIBLE,NO ACCESSOR', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 335, 'A'),
(700336, 100336, 1, 'StockAdjustmentExcel', 'AI', 10336, '5531A0257', 'CRANE ACCES,CURRENT COLLECTOR,ESI,CI-9,G', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 336, 'A'),
(700337, 100337, 1, 'StockAdjustmentExcel', 'AI', 10337, '5531A0293', 'CRANE ACCES;CARBON BRUSH,VAHLE,102980', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 337, 'A'),
(700338, 100338, 1, 'StockAdjustmentExcel', 'AI', 10338, '5531A0448', 'OPERATOR CHAIR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 338, 'A'),
(700339, 100339, 1, 'StockAdjustmentExcel', 'AI', 10339, '5531A0791', 'CRANE DSL INSULATOR  ,VAHLE  ,VDB 45 PHA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 339, 'A'),
(700340, 100340, 1, 'StockAdjustmentExcel', 'AI', 10340, '5539A0029', 'BAT CHRGR;SMF,FLOAT CUM BOOST,NO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 340, 'A'),
(700341, 100341, 1, 'StockAdjustmentExcel', 'AI', 10341, '5540A0328', 'ELECTRONIC CARD PLC PROFIBUS CABLE SEIMENS', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 341, 'A'),
(700342, 100342, 1, 'StockAdjustmentExcel', 'AI', 10342, '5542A0100', 'DRV SPR,FAN,ABB,64650424,ABB DRIVE,ABB,D', 'Toolkit Store', '', '', '', 'nOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 342, 'A'),
(700343, 100343, 1, 'StockAdjustmentExcel', 'AI', 10343, '5542A0280', 'DRV SPR;PULSE COUNTER,ABB,RTAC-01', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 343, 'A'),
(700344, 100344, 1, 'StockAdjustmentExcel', 'AI', 10344, '5542A1157', 'DRIV SPR;CONTROL UNIT CU 310 2 DP', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 344, 'A'),
(700345, 100345, 1, 'StockAdjustmentExcel', 'AI', 10345, '5542A2070', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 345, 'A'),
(700346, 100346, 1, 'StockAdjustmentExcel', 'AI', 10346, '5542A2097', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 346, 'A'),
(700347, 100347, 1, 'StockAdjustmentExcel', 'AI', 10347, '5542A2761', 'COOLING FAN ,SCHNEIDER ,ATV71HC28N4 ,VZ3', 'Toolkit Store', '', '', '', 'NOS', 7, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 347, 'A'),
(700348, 100348, 1, 'StockAdjustmentExcel', 'AI', 10348, '5544A2381', 'BOLT ;HEX HEAD,10MM,30MM,80,SS304', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 348, 'A'),
(700349, 100349, 1, 'StockAdjustmentExcel', 'AI', 10349, '5544A3661', 'BOLT:HEX HEAD 20, MM, 150 MM, SS304', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 349, 'A'),
(700350, 100350, 1, 'StockAdjustmentExcel', 'AI', 10350, '5553A0260', 'CAPACITOR;POLYPROPYLENE,6ÂµF,415V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 350, 'A'),
(700351, 100351, 1, 'StockAdjustmentExcel', 'AI', 10351, '5554A0039', 'LNGT TRF;50 KVA,5% IN 2.5% STEP ,ANAN ,F', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 351, 'A'),
(700352, 100352, 1, 'StockAdjustmentExcel', 'AI', 10352, '5555A0062', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,230 V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 352, 'A'),
(700353, 100353, 1, 'StockAdjustmentExcel', 'AI', 10353, '5555A0071', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,240 V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 353, 'A'),
(700354, 100354, 1, 'StockAdjustmentExcel', 'AI', 10354, '5557A0037', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC-', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 354, 'A'),
(700355, 100355, 1, 'StockAdjustmentExcel', 'AI', 10355, '5558A0035', 'HYD JACK;50TON,150MM,SINGLE ACTING', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 355, 'A'),
(700356, 100356, 1, 'StockAdjustmentExcel', 'AI', 10356, '5563A0915', 'SPARE;COPPER DISC,LADLE FURNACE,LD1', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 356, 'A'),
(700357, 100357, 1, 'StockAdjustmentExcel', 'AI', 10357, '5566A0059', 'CCTV CAM;5MP', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 357, 'A'),
(700358, 100358, 1, 'StockAdjustmentExcel', 'AI', 10358, '5575A0069', 'RCBO;25 A,4 ,415 V,300 MA,C ,50 HZ,50 Â°C', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 358, 'A'),
(700359, 100359, 1, 'StockAdjustmentExcel', 'AI', 10359, '5582A0014', 'VCB;1250A,3,36000V,DRAW OUT TYPE,SHUNT', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 359, 'A'),
(700360, 100360, 1, 'StockAdjustmentExcel', 'AI', 10360, '5582A0039', 'VCB;1250 A,3 ,6600 V,DRAW OUT TYPE ,50 H', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 360, 'A'),
(700361, 100361, 1, 'StockAdjustmentExcel', 'AI', 10361, '5593A0077', 'TEMP TRNTR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 361, 'A'),
(700362, 100362, 1, 'StockAdjustmentExcel', 'AI', 10362, '5593A0099', 'TEMP TRNTR;2 WIRE TEMPERATURE TRANSMITTE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 362, 'A'),
(700363, 100363, 1, 'StockAdjustmentExcel', 'AI', 10363, '5607A0666', 'RELAY;ELECTROMECHANICAL,CONTROL CIRCUIT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 363, 'A'),
(700364, 100364, 1, 'StockAdjustmentExcel', 'AI', 10364, '5607A0671', 'RELAY;ELECTRONIC,IR MEASUREMENT,+/-1%', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 364, 'A'),
(700365, 100365, 1, 'StockAdjustmentExcel', 'AI', 10365, '5607A1125', 'RELAY;ELECTRONIC OVERCURRENT RELAY ,MOTO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 365, 'A'),
(700366, 100366, 1, 'StockAdjustmentExcel', 'AI', 10366, '5607A1297', 'RELAY;ELECTROMAGNETIC ,MAGNET UNDERCURRE', 'Toolkit Store', '', '', '', 'nOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 366, 'A'),
(700367, 100367, 1, 'StockAdjustmentExcel', 'AI', 10367, '5613A0186', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 367, 'A'),
(700368, 100368, 1, 'StockAdjustmentExcel', 'AI', 10368, '5613A0187', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 368, 'A'),
(700369, 100369, 1, 'StockAdjustmentExcel', 'AI', 10369, '5613A0245', 'LMT SWTCH;SNAP ACTION,HEAVY', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 369, 'A'),
(700370, 100370, 1, 'StockAdjustmentExcel', 'AI', 10370, '5620A0226', 'PLC SPR,EN RUSB CARD KIT DRIVEWINDOW 2.3', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 370, 'A'),
(700371, 100371, 1, 'StockAdjustmentExcel', 'AI', 10371, '5620A0719', 'PLC SPR,PRBS KIT ULTRA PRO WTH OPC SRV,P', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 371, 'A'),
(700372, 100372, 1, 'StockAdjustmentExcel', 'AI', 10372, '5620A0987', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 372, 'A'),
(700373, 100373, 1, 'StockAdjustmentExcel', 'AI', 10373, '5620A1046', 'PLC SPR;ANALOG INPUT MODULE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 373, 'A'),
(700374, 100374, 1, 'StockAdjustmentExcel', 'AI', 10374, '5620A1051', 'PLC SPR;REDUNDANCY MODULE,ALLEN BRADLEY', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 374, 'A'),
(700375, 100375, 1, 'StockAdjustmentExcel', 'AI', 10375, '5620A2359', 'ETHERNET MODULE ,CONTROL LOGIX ,1756-EN2', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 375, 'A'),
(700376, 100376, 1, 'StockAdjustmentExcel', 'AI', 10376, '5620A2360', 'CONTROLNET MODULE ,CONTROL LOGIX ,1756-C', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 376, 'A'),
(700377, 100377, 1, 'StockAdjustmentExcel', 'AI', 10377, '5620A2361', 'REDUNDANCY MODULE ,CONTROL LOGIX ,1756-R', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 377, 'A'),
(700378, 100378, 1, 'StockAdjustmentExcel', 'AI', 10378, '5620A2859', 'HMI DISPLAY UNIT ,IBA ,91.000032 ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 378, 'A'),
(700379, 100379, 1, 'StockAdjustmentExcel', 'AI', 10379, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN B', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 379, 'A'),
(700380, 100380, 1, 'StockAdjustmentExcel', 'AI', 10380, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN BR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 380, 'A'),
(700381, 100381, 1, 'StockAdjustmentExcel', 'AI', 10381, '5620A4261', 'IBARACKLINE SAS, XEON E, WIN10 ,IBA ,40.', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 381, 'A'),
(700382, 100382, 1, 'StockAdjustmentExcel', 'AI', 10382, '5623A0361', 'MOTOR&ACCES;FIELD COIL,ABB', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 382, 'A'),
(700383, 100383, 1, 'StockAdjustmentExcel', 'AI', 10383, '5623A0787', 'TACHO WITH OVER SPEED ,HUBNER-GERMANY ,F', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 383, 'A'),
(700384, 100384, 1, 'StockAdjustmentExcel', 'AI', 10384, '5623A1254', 'BRAKE UNIT ,NORD ,BRE150 HL ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 384, 'A'),
(700385, 100385, 1, 'StockAdjustmentExcel', 'AI', 10385, '5631A0004', 'INST CLNG FAN,AC,230V,250MM,50 HZ,115 W', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 385, 'A'),
(700386, 100386, 1, 'StockAdjustmentExcel', 'AI', 10386, '5633A0007', 'RGD CNDUIT,1-1/2INCH,GI,HEAT & CORROSION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 386, 'A'),
(700387, 100387, 1, 'StockAdjustmentExcel', 'AI', 10387, '5641A0160', 'SLCTR SW;6 A,10 WAY 3POSITION STAYPUT ,1', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 387, 'A'),
(700388, 100388, 1, 'StockAdjustmentExcel', 'AI', 10388, '5641a0198', 'selector switch', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 388, 'A'),
(700389, 100389, 1, 'StockAdjustmentExcel', 'AI', 10389, '5641A0198', 'SLCTR SW;10 A,4 POSITION SELECTOR WITH O', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 389, 'A'),
(700390, 100390, 1, 'StockAdjustmentExcel', 'AI', 10390, '5669A0400', 'LFT SPR;INVRTR TKE-1-18.5 7.5KW OL/CL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 390, 'A'),
(700391, 100391, 1, 'StockAdjustmentExcel', 'AI', 10391, '5669A0983', 'DOOR SENSOR (IR SCREEN) ,THYSSENKRUPP ,L', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 391, 'A'),
(700392, 100392, 1, 'StockAdjustmentExcel', 'AI', 10392, '5669A1591', 'THIMBLE ROD ,OTIS ,LIFT ,OTIS ELEVATORS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 392, 'A'),
(700393, 100393, 1, 'StockAdjustmentExcel', 'AI', 10393, '5669A1661', '41 TYPE LOCK RH[NOA6694B2] ,OTIS ,LIFT ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 393, 'A'),
(700394, 100394, 1, 'StockAdjustmentExcel', 'AI', 10394, '5669A1991', 'DOOR WIRE CORD ,OTIS ,LIFT ,OTIS ELEVATO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 394, 'A'),
(700395, 100395, 1, 'StockAdjustmentExcel', 'AI', 10395, '5669A2015', 'CAR GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 395, 'A'),
(700396, 100396, 1, 'StockAdjustmentExcel', 'AI', 10396, '5669A2016', 'CWT GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 396, 'A'),
(700397, 100397, 1, 'StockAdjustmentExcel', 'AI', 10397, '5681A0070', 'LIFTNG SHKL;12.5 TON,8 ,35.5 mm', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 397, 'A'),
(700398, 100398, 1, 'StockAdjustmentExcel', 'AI', 10398, '5684A0072', 'SPL LGHT;EMERGENCY,YES,PORTABLE,220VAC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 398, 'A'),
(700399, 100399, 1, 'StockAdjustmentExcel', 'AI', 10399, '5684A0190', 'SPL LGHT;RECHARGEABLE EMERGENCY LAMP ,YE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 399, 'A'),
(700400, 100400, 1, 'StockAdjustmentExcel', 'AI', 10400, '5694A0470', 'NO SPECIAL FEATURES ,CUTTING DISC ,BOSCH', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 400, 'A'),
(700401, 100401, 1, 'StockAdjustmentExcel', 'AI', 10401, '5700A0854', 'FLD SNSR;OPTICAL DISTANCE SENSOR(LASER)', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 401, 'A'),
(700402, 100402, 1, 'StockAdjustmentExcel', 'AI', 10402, '5700A0946', 'FLD SNSR;Vibration Sensor ,BENTALY NAVAD', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 402, 'A'),
(700403, 100403, 1, 'StockAdjustmentExcel', 'AI', 10403, '5701A0088', 'ELECT SOCKT/PLG;32A,METALLIC,5,PLUG', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 403, 'A'),
(700404, 100404, 1, 'StockAdjustmentExcel', 'AI', 10404, '5701A0093', 'ELECT SOCKT/PLG;125A,METALLIC,5,PLUG', 'Toolkit Store', '', '', '', 'NOS', 22, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 404, 'A'),
(700405, 100405, 1, 'StockAdjustmentExcel', 'AI', 10405, '5701A0095', 'ELECT SOCKT/PLG;32A,METALLIC,5,SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 405, 'A'),
(700406, 100406, 1, 'StockAdjustmentExcel', 'AI', 10406, '5701A0096', 'ELECT SOCKT/PLG;63A,METALLIC,5,SOCKET', 'Toolkit Store', '', '', '', 'NOS', 4, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 406, 'A'),
(700407, 100407, 1, 'StockAdjustmentExcel', 'AI', 10407, '5701A0097', 'ELECT SOCKT/PLG;125A,METALLIC,5,SOCKET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 407, 'A');
INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(700408, 100408, 1, 'StockAdjustmentExcel', 'AI', 10408, '5701A0100', 'ELECT SOCKT/PLG;63A', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 408, 'A'),
(700409, 100409, 1, 'StockAdjustmentExcel', 'AI', 10409, '5701A0141', 'EL SKT/PLG;20A,METAL CLAD,3', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 409, 'A'),
(700410, 100410, 1, 'StockAdjustmentExcel', 'AI', 10410, '5701A0142', 'EL SKT/PLG;20A,METAL CLAD,2,SOCKET,230V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 410, 'A'),
(700411, 100411, 1, 'StockAdjustmentExcel', 'AI', 10411, '5715A0462', 'OMEGA 904  ,MAGNA  ,OMEGA 904  ,5  LITER', 'Toolkit Store', '', '', '', 'LIT', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 411, 'A'),
(700412, 100412, 1, 'StockAdjustmentExcel', 'AI', 10412, '5715A0599', 'SEAL LEAK PROOF OIL ,OMEGA ,OMEGA 917 ,5', 'Toolkit Store', '', '', '', 'LIT', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 412, 'A'),
(700413, 100413, 1, 'StockAdjustmentExcel', 'AI', 10413, '5717A0048', 'LT CABLE 16CX2.5MMSQ TINNED COPPER ELASTOMER', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 413, 'A'),
(700414, 100414, 1, 'StockAdjustmentExcel', 'AI', 10414, '5717A0366', 'LT CABLE 12CX2.5SQMM TINNED COPPER', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 414, 'A'),
(700415, 100415, 1, 'StockAdjustmentExcel', 'AI', 10415, '5717A0467', 'LT CBL;6,6MM2,COPPER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 415, 'A'),
(700416, 100416, 1, 'StockAdjustmentExcel', 'AI', 10416, '5717A0910', 'LT CBL;8 ,PVC-ST2-FRLSH ,ANNEALED BARE C', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 416, 'A'),
(700417, 100417, 1, 'StockAdjustmentExcel', 'AI', 10417, '5717A1002', 'LT CBL;2 ,CSP-FRLSH ,ANNEALED TINNED COP', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 417, 'A'),
(700418, 100418, 1, 'StockAdjustmentExcel', 'AI', 10418, '5717A1014', 'LT CBL;4 ,CSP-FRLSH ,ANNEALED TINNED COP', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 418, 'A'),
(700419, 100419, 1, 'StockAdjustmentExcel', 'AI', 10419, '5739A0008', 'TIMER;ELECTRONIC MULTIMODE TIMER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 419, 'A'),
(700420, 100420, 1, 'StockAdjustmentExcel', 'AI', 10420, '5748A0181', 'FUSE,FLUKE MULTIMETER FUSE,440MA,1000V,3', 'Toolkit Store', '', '', '', 'NOS', 4, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 420, 'A'),
(700421, 100421, 1, 'StockAdjustmentExcel', 'AI', 10421, '5748A0609', 'FUSE;HRC,400A,500V,120KA,AC', 'Toolkit Store', '', '', '', 'NOS', 25, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 421, 'A'),
(700422, 100422, 1, 'StockAdjustmentExcel', 'AI', 10422, '5748A0730', 'FUSE;SEMICONDUCTOR,1100A,1000V,100KA,AC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 422, 'A'),
(700423, 100423, 1, 'StockAdjustmentExcel', 'AI', 10423, '5751A0049', 'ALCOHOL RUBIN STERILE HAND DIS ,500 ML,N', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 423, 'A'),
(700424, 100424, 1, 'StockAdjustmentExcel', 'AI', 10424, '5761A0136', 'ELECT BOX;JUNCTION BOX,UP TO 1.1KV,WALL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 424, 'A'),
(700425, 100425, 1, 'StockAdjustmentExcel', 'AI', 10425, '5761A0316', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 425, 'A'),
(700426, 100426, 1, 'StockAdjustmentExcel', 'AI', 10426, '5761A0317', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 426, 'A'),
(700427, 100427, 1, 'StockAdjustmentExcel', 'AI', 10427, '5761A0318', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 427, 'A'),
(700428, 100428, 1, 'StockAdjustmentExcel', 'AI', 10428, '5761A0319', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 428, 'A'),
(700429, 100429, 1, 'StockAdjustmentExcel', 'AI', 10429, '5761A0320', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 429, 'A'),
(700430, 100430, 1, 'StockAdjustmentExcel', 'AI', 10430, '5761A0321', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 430, 'A'),
(700431, 100431, 1, 'StockAdjustmentExcel', 'AI', 10431, '5761A0322', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 431, 'A'),
(700432, 100432, 1, 'StockAdjustmentExcel', 'AI', 10432, '5761A0323', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 432, 'A'),
(700433, 100433, 1, 'StockAdjustmentExcel', 'AI', 10433, '5761A0326', 'EL BOX;GROUNDING POINT NOT REQUIRE ,JUNC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 433, 'A'),
(700434, 100434, 1, 'StockAdjustmentExcel', 'AI', 10434, '5772A0143', 'PUSH BTN;PB STATION ,GREEN ,TEKNIC ,FLUS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 434, 'A'),
(700435, 100435, 1, 'StockAdjustmentExcel', 'AI', 10435, '5772A0144', 'PUSH BTN;FLUSH MOUNTED P.B ,GREEN ,TEKNI', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 435, 'A'),
(700436, 100436, 1, 'StockAdjustmentExcel', 'AI', 10436, '5772A0185', 'PUSH BTN;PUSH BUTTON ACTUATOR ,GREEN ,TE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 436, 'A'),
(700437, 100437, 1, 'StockAdjustmentExcel', 'AI', 10437, '5772A0310', 'PUSH BTN;PUSH BUTTON ACTUATOR ,BLUE ,TEK', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 437, 'A'),
(700438, 100438, 1, 'StockAdjustmentExcel', 'AI', 10438, '5775A0005', 'LV HAND GLOVES;9 ,', 'Toolkit Store', '', '', '', 'PAA', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 438, 'A'),
(700439, 100439, 1, 'StockAdjustmentExcel', 'AI', 10439, '5789A0075', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 439, 'A'),
(700440, 100440, 1, 'StockAdjustmentExcel', 'AI', 10440, '5789A0076', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:35', 'usertool', 20001, 440, 'A'),
(700441, 100441, 1, 'StockAdjustmentExcel', 'AI', 10441, '5789A0077', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 441, 'A'),
(700442, 100442, 1, 'StockAdjustmentExcel', 'AI', 10442, '5789A0102', 'OFFC ACCS;WIRELESS MOUSE {HP X3500}', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 442, 'A'),
(700443, 100443, 1, 'StockAdjustmentExcel', 'AI', 10443, '5789A0192', 'UMBRELLA WITH WOODEN HANDLE ,ANY ,UMBREL', 'Toolkit Store', '', '', '', 'NOS', 4, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 443, 'A'),
(700444, 100444, 1, 'StockAdjustmentExcel', 'AI', 10444, '5794A0309', 'CBL SCKT;PIN,1.5MM2,COPPER,STRAIGHT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 444, 'A'),
(700445, 100445, 1, 'StockAdjustmentExcel', 'AI', 10445, '5794A0310', 'CBL SCKT;PIN,2.5MM2,COPPER,STRAIGHT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 445, 'A'),
(700446, 100446, 1, 'StockAdjustmentExcel', 'AI', 10446, '5803A1238', 'SPL HOSE;HYDRAULIC HOSE 6\" LONG ,HC7206', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 446, 'A'),
(700447, 100447, 1, 'StockAdjustmentExcel', 'AI', 10447, '5811A1619', 'GEAR COUPLING 2 ,LD#1 ,CRANE ,AS PER DRA', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 447, 'A'),
(700448, 100448, 1, 'StockAdjustmentExcel', 'AI', 10448, '5811A2507', 'CRANE SHAFT ,LD#1 ,CRANE ,AS PER DRAWING', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 448, 'A'),
(700449, 100449, 1, 'StockAdjustmentExcel', 'AI', 10449, '5811A3304', 'HG 1050 INPUT PINION SHAFT  ,LD#1  ,BOF', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 449, 'A'),
(700450, 100450, 1, 'StockAdjustmentExcel', 'AI', 10450, '5811A4473', 'HG 1050 2ND INTERMEDIATE PINIO ,LD1 ,VES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 450, 'A'),
(700451, 100451, 1, 'StockAdjustmentExcel', 'AI', 10451, '5811A4474', 'HG 1050 2ND GEAR ,LD1 ,VESSEL ,AS PER DR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 451, 'A'),
(700452, 100452, 1, 'StockAdjustmentExcel', 'AI', 10452, '5811A4475', 'HG 1050 1ST GEAR ,LD1 ,VESSEL ,AS PER DR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 452, 'A'),
(700453, 100453, 1, 'StockAdjustmentExcel', 'AI', 10453, '5811A4476', 'HG 1050 1ST INTERMEDIATE PINIO ,LD1 ,VES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 453, 'A'),
(700454, 100454, 1, 'StockAdjustmentExcel', 'AI', 10454, '5811A4477', 'HG 1050 INPUT PINION SHAFT ,LD1 ,VESSEL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 454, 'A'),
(700455, 100455, 1, 'StockAdjustmentExcel', 'AI', 10455, '5811A4486', 'HG 1050 3RD INTERMIDIATE PINIO ,LD1 ,VES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 455, 'A'),
(700456, 100456, 1, 'StockAdjustmentExcel', 'AI', 10456, '5811A4487', 'HG 1050 3RD GEAR ,LD1 ,VESSEL ,AS PER DR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 456, 'A'),
(700457, 100457, 1, 'StockAdjustmentExcel', 'AI', 10457, '5811A4497', 'HG 1050 4TH GEAR ,LD1 ,VESSEL ,AS PER DR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 457, 'A'),
(700458, 100458, 1, 'StockAdjustmentExcel', 'AI', 10458, '5811A4675', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 458, 'A'),
(700459, 100459, 1, 'StockAdjustmentExcel', 'AI', 10459, '5811A4676', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 459, 'A'),
(700460, 100460, 1, 'StockAdjustmentExcel', 'AI', 10460, '5845A0109', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 460, 'A'),
(700461, 100461, 1, 'StockAdjustmentExcel', 'AI', 10461, '5845A0112', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 461, 'A'),
(700462, 100462, 1, 'StockAdjustmentExcel', 'AI', 10462, '5847A0306', 'WIRE ROPE;28 MM,RHO ,1770 N/MM2,150 M RO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 462, 'A'),
(700463, 100463, 1, 'StockAdjustmentExcel', 'AI', 10463, '5847a0340', 'WIRE ROPE;22 MM,RHO ,1770 N/MM2,100 M RO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 463, 'A'),
(700464, 100464, 1, 'StockAdjustmentExcel', 'AI', 10464, '5847a0351', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 464, 'A'),
(700465, 100465, 1, 'StockAdjustmentExcel', 'AI', 10465, '5848A0002', 'POWR TESTR;HT POWER TESTER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 465, 'A'),
(700466, 100466, 1, 'StockAdjustmentExcel', 'AI', 10466, '5849A0049', 'CNDTR;CU-AL BIMETALLIC SHEET ,COPPER CLA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 466, 'A'),
(700467, 100467, 1, 'StockAdjustmentExcel', 'AI', 10467, '5854A0035', 'SAFE;FIRE RETARDANT,XXXL,ORANGE,BLUE,NA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 467, 'A'),
(700468, 100468, 1, 'StockAdjustmentExcel', 'AI', 10468, '5859A0004', 'INSULATING MATL,TAPE,TOUGARD,10MX5CM,0,P', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 468, 'A'),
(700469, 100469, 1, 'StockAdjustmentExcel', 'AI', 10469, '5859A0120', 'INSULATING MATL,SHEET,FIBRE INSULATOR,73', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 469, 'A'),
(700470, 100470, 1, 'StockAdjustmentExcel', 'AI', 10470, '5859A0298', 'INSULATING MATL;TAPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 470, 'A'),
(700471, 100471, 1, 'StockAdjustmentExcel', 'AI', 10471, '5859A0315', 'INSULATING MATL;SLEEVE', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 471, 'A'),
(700472, 100472, 1, 'StockAdjustmentExcel', 'AI', 10472, '5867A0345', 'CRBN BRS;EG14 ,VINAYAK CARBON ,CARBON BR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 472, 'A'),
(700473, 100473, 1, 'StockAdjustmentExcel', 'AI', 10473, '5870A1809', 'MATL PROJCT;Spike BusterSET', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 473, 'A'),
(700474, 100474, 1, 'StockAdjustmentExcel', 'AI', 10474, '5872A0113', 'SW GR&CB SPR,CONTACT KIT,BCH,CONTACTOR,9', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 474, 'A'),
(700475, 100475, 1, 'StockAdjustmentExcel', 'AI', 10475, '5872A0418', 'SW GR&CB SPR,AUX CONTACT,ABB,CONTACTOR,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 475, 'A'),
(700476, 100476, 1, 'StockAdjustmentExcel', 'AI', 10476, '5872A1298', 'SW GR&CB SPR,PANEL KEY,PRECISION SPARES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 476, 'A'),
(700477, 100477, 1, 'StockAdjustmentExcel', 'AI', 10477, '5872A1709', 'SW GR&CB SPR,PAD LOCKING KIT,SCNEDR ELEC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 477, 'A'),
(700478, 100478, 1, 'StockAdjustmentExcel', 'AI', 10478, '5872A2046', 'S/GR SPR;MECH ASMBLY OF VAC INTERRUPTER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 478, 'A'),
(700479, 100479, 1, 'StockAdjustmentExcel', 'AI', 10479, '5872A2047', 'S/GR SPR;VACCUM INTERRUPTER (BOTTLE)', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 479, 'A'),
(700480, 100480, 1, 'StockAdjustmentExcel', 'AI', 10480, '5872A2197', 'CLOSE CASTING PENDANT ,SMS CONCAST ,MOUL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 480, 'A'),
(700481, 100481, 1, 'StockAdjustmentExcel', 'AI', 10481, '5872A2273', 'DC CONTACT TIP FIXED ,NA ,900 A GE TYPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 481, 'A'),
(700482, 100482, 1, 'StockAdjustmentExcel', 'AI', 10482, '5872A2279', 'SURGE PROTECTION DEVICE( 24 ,DEHN ,OPACI', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 482, 'A'),
(700483, 100483, 1, 'StockAdjustmentExcel', 'AI', 10483, '5872A2283', 'DC CONTACT TIP MOVING ,GE ,900 A GE TYPE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 483, 'A'),
(700484, 100484, 1, 'StockAdjustmentExcel', 'AI', 10484, '5885A0282', 'PROXIMITY;ANALOG PROXIMITY SWITCH,0-4MM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 484, 'A'),
(700485, 100485, 1, 'StockAdjustmentExcel', 'AI', 10485, '5885A0289', 'PROXMTY;INDUCTIVE SENSOR,20MM,10-30V', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 485, 'A'),
(700486, 100486, 1, 'StockAdjustmentExcel', 'AI', 10486, '5885A0326', 'PROXMTY;INDUCTIVE,4MM,10-30V,IP68', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 486, 'A'),
(700487, 100487, 1, 'StockAdjustmentExcel', 'AI', 10487, '5890A0715', 'CONTCR;110A,3,110V,POWER,415V,S6,AC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 487, 'A'),
(700488, 100488, 1, 'StockAdjustmentExcel', 'AI', 10488, '5890A0723', 'CONTCR;140A,3,110V,POWER,415V,S6,AC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 488, 'A'),
(700489, 100489, 1, 'StockAdjustmentExcel', 'AI', 10489, '5890a0734', 'CONTCOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 489, 'A'),
(700490, 100490, 1, 'StockAdjustmentExcel', 'AI', 10490, '5890A0854', 'CONTCR;70A,3,110V,POWER,415V,8,AC,50HZ', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 490, 'A'),
(700491, 100491, 1, 'StockAdjustmentExcel', 'AI', 10491, '5890A0969', 'CNTCR;900 A,1 ,220 V,DC ,660 V,DC ,2NO+2', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 491, 'A'),
(700492, 100492, 1, 'StockAdjustmentExcel', 'AI', 10492, '5890A1027', 'CNTCR;20 A,2 NOS,240 VAC,DC ,415 V,SIZE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 492, 'A'),
(700493, 100493, 1, 'StockAdjustmentExcel', 'AI', 10493, '5890A1070', 'CNTCR;300 A,3 ,220 V,POWER ,415 V,S10 ,A', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 493, 'A'),
(700494, 100494, 1, 'StockAdjustmentExcel', 'AI', 10494, '5893A0420', 'CONTACT PAD COPPER RING ,PRECISION SPARE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 494, 'A'),
(700495, 100495, 1, 'StockAdjustmentExcel', 'AI', 10495, '5899A0046', 'HAND  WASING PASTE', 'Toolkit Store', '', '', '', 'kg', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 495, 'A'),
(700496, 100496, 1, 'StockAdjustmentExcel', 'AI', 10496, '5899A0069', 'AUTOMATIC SOAP DISPENSER  ,NA  ,NOT APPL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 496, 'A'),
(700497, 100497, 1, 'StockAdjustmentExcel', 'AI', 10497, '5900A2144', 'AC MOTR;0.18 KW,415 Â± 10% V,SQUIRREL CAG', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 497, 'A'),
(700498, 100498, 1, 'StockAdjustmentExcel', 'AI', 10498, '5900A3424', 'AC MOTR;IE2 ,0.25 KW,415 Â± 10% V,SQUIRRE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 498, 'A'),
(700499, 100499, 1, 'StockAdjustmentExcel', 'AI', 10499, '5900A3570', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 499, 'A'),
(700500, 100500, 1, 'StockAdjustmentExcel', 'AI', 10500, '5900A3653', 'AC MOTR;IE2 ,3.7 KW,415 Â± 10% V,SQUIRREL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 500, 'A'),
(700501, 100501, 1, 'StockAdjustmentExcel', 'AI', 10501, '5900A3927', 'AC MOTR;IE2 ,7.5 KW,390 +10%/-10% V,SQUI', 'Toolkit Store', '', '', '', 'nOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 501, 'A'),
(700502, 100502, 1, 'StockAdjustmentExcel', 'AI', 10502, '5905A0003', 'P ISLN;POSITIVE ISO PAD LOCK YELLOW', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 502, 'A'),
(700503, 100503, 1, 'StockAdjustmentExcel', 'AI', 10503, '5914A0169', 'SHOE POLISH,STANDARD,HEAVY METAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 503, 'A'),
(700504, 100504, 1, 'StockAdjustmentExcel', 'AI', 10504, '5918A1049', 'GRINDING MACHINE ,DEWALT ,DW801-B1 ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 504, 'A'),
(700505, 100505, 1, 'StockAdjustmentExcel', 'AI', 10505, '5924A0116', 'SPL MOTR;LINEAR ACTUATOR FOR CC1', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 505, 'A'),
(700506, 100506, 1, 'StockAdjustmentExcel', 'AI', 10506, '5924A0268', 'SPL MOTR;CIRCULATION PUMP ,BEACON WEIR L', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 506, 'A'),
(700507, 100507, 1, 'StockAdjustmentExcel', 'AI', 10507, '5924A0278', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 507, 'A'),
(700508, 100508, 1, 'StockAdjustmentExcel', 'AI', 10508, '5924A0378', 'SPL MOTR;0.23 KW 2800 RPM UNBLCE MOTOR ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 508, 'A'),
(700509, 100509, 1, 'StockAdjustmentExcel', 'AI', 10509, '5924A0636', 'SPL MOTR;STOPPER MECHANISM COMPLETE ,SMS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 509, 'A'),
(700510, 100510, 1, 'StockAdjustmentExcel', 'AI', 10510, '5924A0681', 'SPL MOTR;HYDRAULIC PUMP MOTOR ,SIEMENS ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 510, 'A'),
(700511, 100511, 1, 'StockAdjustmentExcel', 'AI', 10511, '5929A0003', 'BRAK MTR;BRAKE MOTORS,0.37KW', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 511, 'A'),
(700512, 100512, 1, 'StockAdjustmentExcel', 'AI', 10512, '5929A0046', 'BRAK MOTR;CARRIAGE MOTOR ,1.1 KW,SMS CON', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 512, 'A'),
(700513, 100513, 1, 'StockAdjustmentExcel', 'AI', 10513, '5953A0075', 'FIVE SLOT CABLE PROTECTOR UNIT,STANDARD', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 513, 'A'),
(700514, 100514, 1, 'StockAdjustmentExcel', 'AI', 10514, '5956A0522', 'INST SPR;MOULD LEVEL DETECTOR CC2/CC3', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 514, 'A'),
(700515, 100515, 1, 'StockAdjustmentExcel', 'AI', 10515, '5956A0633', 'INST SPR;VIBRATION SENSOR VERTICAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 515, 'A'),
(700516, 100516, 1, 'StockAdjustmentExcel', 'AI', 10516, '5956A0634', 'INST SPR;VIBRATION SENSOR HORIZONTAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 516, 'A'),
(700517, 100517, 1, 'StockAdjustmentExcel', 'AI', 10517, '5956A0680', 'INST SPR;Contact Block for temp S 2 Co', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 517, 'A'),
(700518, 100518, 1, 'StockAdjustmentExcel', 'AI', 10518, '5956A0929', 'INST SPR;SIGNAL ISOLATOR,MASIBUS', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 518, 'A'),
(700519, 100519, 1, 'StockAdjustmentExcel', 'AI', 10519, '5956A0930', 'INST SPR;CONTACT BLOCK FOR TEMP B 2 COR', 'Toolkit Store', '', '', '', 'NOS', 30, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 519, 'A'),
(700520, 100520, 1, 'StockAdjustmentExcel', 'AI', 10520, '5956A1492', 'INST SPR TEMP & OXY MEASUREMENT PROBEF', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 520, 'A'),
(700521, 100521, 1, 'StockAdjustmentExcel', 'AI', 10521, '5956A2043', 'SCINTILLATION COUNTER ,BERTHOLD TECHNOLO', 'Toolkit Store', '', '', '', 'SET', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 521, 'A'),
(700522, 100522, 1, 'StockAdjustmentExcel', 'AI', 10522, '5958A0019', 'CONT BLK;ELECTRICAL PANEL,TEKNIC,NO,1', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 522, 'A'),
(700523, 100523, 1, 'StockAdjustmentExcel', 'AI', 10523, '5964A0171', 'PNL;WELDING MACHINE SAFETY PANEL ,450X44', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 523, 'A'),
(700524, 100524, 1, 'StockAdjustmentExcel', 'AI', 10524, '5964a0196', 'PNL;RIO PANEL ,NO SPECIAL FEATURES ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 524, 'A'),
(700525, 100525, 1, 'StockAdjustmentExcel', 'AI', 10525, '5964A0209', 'PNL;CONTROL DESK WITHOUT HMI ,NO SPECIAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 525, 'A'),
(700526, 100526, 1, 'StockAdjustmentExcel', 'AI', 10526, '5965A1903', 'BENCH GRINDER NOS,STGB 3715 ,STANLEY ,1/', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 526, 'A'),
(700527, 100527, 1, 'StockAdjustmentExcel', 'AI', 10527, '5968A0022', 'SPARE,ELECTRONIC;VGA TO HDMI CONVERTER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 527, 'A'),
(700528, 100528, 1, 'StockAdjustmentExcel', 'AI', 10528, '5968A0023', 'SPARE,ELECTRONIC;HDMI Cable', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 528, 'A'),
(700529, 100529, 1, 'StockAdjustmentExcel', 'AI', 10529, '5971A0237', 'EPOXY BASED PROTECTIVE COATING ,LOCTITE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 529, 'A'),
(700530, 100530, 1, 'StockAdjustmentExcel', 'AI', 10530, '5995a0026', 'RAD ACT INST;CO-60 ROD SOURCE ,GAMMA RAY', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 530, 'A'),
(700531, 100531, 1, 'StockAdjustmentExcel', 'AI', 10531, '5995A0027', 'RAD ACT INST;SHIELDING FOR AMLC SOURCE ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 531, 'A'),
(700532, 100532, 1, 'StockAdjustmentExcel', 'AI', 10532, '5997a0035', 'CONTROL STOP INDICATION SYSTEM ,BALAJI E', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 532, 'A'),
(700533, 100533, 1, 'StockAdjustmentExcel', 'AI', 10533, '6008A0002', 'N/W PASSIVE DEVICE FO CABLE', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 533, 'A'),
(700534, 100534, 1, 'StockAdjustmentExcel', 'AI', 10534, '6010A0001', 'N/W PASSIVE HDPE PIPE/DWC DUCT', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 534, 'A'),
(700535, 100535, 1, 'StockAdjustmentExcel', 'AI', 10535, '6015A0001', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 535, 'A'),
(700536, 100536, 1, 'StockAdjustmentExcel', 'AI', 10536, '6015A0002', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 536, 'A'),
(700537, 100537, 1, 'StockAdjustmentExcel', 'AI', 10537, '6021A0056', 'EL TSTG INST;CONTACT RESISTANCE MEASUREM', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 537, 'A'),
(700538, 100538, 1, 'StockAdjustmentExcel', 'AI', 10538, '6024A0040', 'HIGH TEMPERATURE ADHESIVE TAPE ,50 MM,SA', 'Toolkit Store', '', '', '', 'RLL', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 538, 'A'),
(700539, 100539, 1, 'StockAdjustmentExcel', 'AI', 10539, '6028A0061', 'POWER DISTRIBUTION ACCESSORIES', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 539, 'A'),
(700540, 100540, 1, 'StockAdjustmentExcel', 'AI', 10540, '6028A0062', 'POWER DISTRIBUTION ACCESSORIES', 'Toolkit Store', '', '', '', 'NOS', 1, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 540, 'A'),
(700541, 100541, 1, 'StockAdjustmentExcel', 'AI', 10541, '6045A0002', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 541, 'A'),
(700542, 100542, 1, 'StockAdjustmentExcel', 'AI', 10542, '6045A0028', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 542, 'A'),
(700543, 100543, 1, 'StockAdjustmentExcel', 'AI', 10543, '6045A0136', 'SPL CBL;CABLES FOR SERVO MOTOR ,LAPP IND', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 543, 'A'),
(700544, 100544, 1, 'StockAdjustmentExcel', 'AI', 10544, '6045A0143', 'SPL CBL;RESOLVER CABLE FOR STOPPER BOX ,', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 544, 'A'),
(700545, 100545, 1, 'StockAdjustmentExcel', 'AI', 10545, '6045A0157', 'SPL CBL;ENCODER CONNECTOR WITH CABLE ,KU', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 545, 'A'),
(700546, 100546, 1, 'StockAdjustmentExcel', 'AI', 10546, '6049A0066', 'SPL INST;TEMPERATURE STICKER ,TEMPERATUR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 546, 'A'),
(700547, 100547, 1, 'StockAdjustmentExcel', 'AI', 10547, '6093A0007', 'LUMR;HIGHBAY,160W,AC,140 - 270V,NO,YES', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 547, 'A'),
(700548, 100548, 1, 'StockAdjustmentExcel', 'AI', 10548, '6093A0014', 'LUMR;WELL GLASS,29W,AC,140 - 270V,NO', 'Toolkit Store', '', '', '', 'Nos.', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 548, 'A'),
(700549, 100549, 1, 'StockAdjustmentExcel', 'AI', 10549, '6122A0082', 'CABLE ACCESSORIES;450  V,TYPE:U1K16  ,TE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 549, 'A'),
(700550, 100550, 1, 'StockAdjustmentExcel', 'AI', 10550, '6125A0054', 'THZ WAVE RADAR LEVEL TRANSMITT ,PRIBUSIN', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 550, 'A'),
(700551, 100551, 1, 'StockAdjustmentExcel', 'AI', 10551, '6125A0058', 'SPD_230V SINGLE PHASE ,DEHN ,900351 ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 551, 'A'),
(700552, 100552, 1, 'StockAdjustmentExcel', 'AI', 10552, '6128A0018', 'LARGE DIGITAL INDICATOR ,MASIBUS ,409-4I', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 552, 'A'),
(700553, 100553, 1, 'StockAdjustmentExcel', 'AI', 10553, '6130A0017', 'TEMPERATURE & HUMIDITY DISPLAY ,CASIO ,I', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 553, 'A'),
(700554, 100554, 1, 'StockAdjustmentExcel', 'AI', 10554, '6131A0024', 'DISPLAY FOR MAG FLOW ,YOKOGAWA ,F9802JA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 554, 'A'),
(700555, 100555, 1, 'StockAdjustmentExcel', 'AI', 10555, '6132A0805', 'SPARE VALVE STAND FOR HOOD PRS ,SATYATEK', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 555, 'A'),
(700556, 100556, 1, 'StockAdjustmentExcel', 'AI', 10556, '6142A0003', 'STP;KRAMER ,NOT APPLICABLE ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 556, 'A'),
(700557, 100557, 1, 'StockAdjustmentExcel', 'AI', 10557, '6183A0009', 'MASTER CONTROLLER;220 VAC,10 A,4-0-4 ,BI', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 557, 'A'),
(700558, 100558, 1, 'StockAdjustmentExcel', 'AI', 10558, '6183A0017', 'MASTER CONTROLLER;400 VAC/DC,16 A,4-0-4', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 558, 'A'),
(700559, 100559, 1, 'StockAdjustmentExcel', 'AI', 10559, '6183A0039', 'MASTER CONTROLLER;400 VAC/DC,10 A,1-0-1', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 559, 'A'),
(700560, 100560, 1, 'StockAdjustmentExcel', 'AI', 10560, '6186A0037', 'NW SPARES;LSZH PATCH CORD CAT6A , 10 M', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 560, 'A'),
(700561, 100561, 1, 'StockAdjustmentExcel', 'AI', 10561, '6186A0076', 'NW SPARES;WS-C3850X-12S-E CATALYST 3850X', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 561, 'A'),
(700562, 100562, 1, 'StockAdjustmentExcel', 'AI', 10562, '6186A0273', 'NW SPARES;6U WALL MOUNT NETWORK RACK WIT', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 562, 'A'),
(700563, 100563, 1, 'StockAdjustmentExcel', 'AI', 10563, '6186A0279', 'NW SPARES;6U FLOOR MOUNT OUTDOOR CABINE', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 563, 'A'),
(700564, 100564, 1, 'StockAdjustmentExcel', 'AI', 10564, '6186A0297', 'NW SPARES;12 PORT LOADED FIBER LIU RACK', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 564, 'A'),
(700565, 100565, 1, 'StockAdjustmentExcel', 'AI', 10565, '6186A0301', 'NW SPARES;FIBER OPTIC CABLE (6 CORE) MM', 'Toolkit Store', '', '', '', 'M', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 565, 'A'),
(700566, 100566, 1, 'StockAdjustmentExcel', 'AI', 10566, '6186A0310', 'NW SPARES;6 CORE SM FO CABLE,LOOSE TUBE', 'Toolkit Store', '', '', '', 'MTR', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 566, 'A'),
(700567, 100567, 1, 'StockAdjustmentExcel', 'AI', 10567, '6186A0317', 'NW SPARES;LC-SC FO PATCH CORD, DUPLEX, O', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 567, 'A'),
(700568, 100568, 1, 'StockAdjustmentExcel', 'AI', 10568, '6186A0326', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 2', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 568, 'A'),
(700569, 100569, 1, 'StockAdjustmentExcel', 'AI', 10569, '6186A0327', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 15', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 569, 'A'),
(700570, 100570, 1, 'StockAdjustmentExcel', 'AI', 10570, '6186A0328', 'NW SPARES;CAT 6A S/FTP CABLE (500 METER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 570, 'A'),
(700571, 100571, 1, 'StockAdjustmentExcel', 'AI', 10571, '6186A0331', 'NW SPARES;CAT6A STP PATCH CRD 2M LSZH ,N', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 571, 'A'),
(700572, 100572, 1, 'StockAdjustmentExcel', 'AI', 10572, '6186A0357', 'NW SPARES;SC PIGTAIL MM OM1 SIMPLEX LSZH', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 572, 'A'),
(700573, 100573, 1, 'StockAdjustmentExcel', 'AI', 10573, '6186A0359', 'NW SPARES;PATCH CRD;FIBER MULTIMODE DUPL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 573, 'A'),
(700574, 100574, 1, 'StockAdjustmentExcel', 'AI', 10574, '6186A0370', 'NW SPARES;SWITCH ,WS-C2960CX-8TC-L ,', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 574, 'A'),
(700575, 100575, 1, 'StockAdjustmentExcel', 'AI', 10575, '6186A0371', 'NW SPARES;FIREWALL ,FORTIGATE 60E ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 575, 'A'),
(700576, 100576, 1, 'StockAdjustmentExcel', 'AI', 10576, '6204A0001', 'SHUNT FOR CONTACTOR;300 A,BRAIDED WIRE ,', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 576, 'A'),
(700577, 100577, 1, 'StockAdjustmentExcel', 'AI', 10577, '5669A0441', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 577, 'A'),
(700578, 100578, 1, 'StockAdjustmentExcel', 'AI', 10578, '5669A0983', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 578, 'A'),
(700579, 100579, 1, 'StockAdjustmentExcel', 'AI', 10579, '5669A0566', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 579, 'A'),
(700580, 100580, 1, 'StockAdjustmentExcel', 'AI', 10580, '5669A1521', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 580, 'A'),
(700581, 100581, 1, 'StockAdjustmentExcel', 'AI', 10581, '5669A0895', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 581, 'A'),
(700582, 100582, 1, 'StockAdjustmentExcel', 'AI', 10582, '5669A1519', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 582, 'A'),
(700583, 100583, 1, 'StockAdjustmentExcel', 'AI', 10583, '5900A1468', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 583, 'A'),
(700584, 100584, 1, 'StockAdjustmentExcel', 'AI', 10584, '5900A1505', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 584, 'A'),
(700585, 100585, 1, 'StockAdjustmentExcel', 'AI', 10585, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 585, 'A'),
(700586, 100586, 1, 'StockAdjustmentExcel', 'AI', 10586, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 586, 'A'),
(700587, 100587, 1, 'StockAdjustmentExcel', 'AI', 10587, '5900A0971', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 587, 'A'),
(700588, 100588, 1, 'StockAdjustmentExcel', 'AI', 10588, '5900A1469', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 588, 'A'),
(700589, 100589, 1, 'StockAdjustmentExcel', 'AI', 10589, '5900A0885', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 589, 'A'),
(700590, 100590, 1, 'StockAdjustmentExcel', 'AI', 10590, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 590, 'A'),
(700591, 100591, 1, 'StockAdjustmentExcel', 'AI', 10591, '5900A1088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 591, 'A'),
(700592, 100592, 1, 'StockAdjustmentExcel', 'AI', 10592, '5900A1289', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 592, 'A'),
(700593, 100593, 1, 'StockAdjustmentExcel', 'AI', 10593, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 593, 'A'),
(700594, 100594, 1, 'StockAdjustmentExcel', 'AI', 10594, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 594, 'A'),
(700595, 100595, 1, 'StockAdjustmentExcel', 'AI', 10595, '5555A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 595, 'A'),
(700596, 100596, 1, 'StockAdjustmentExcel', 'AI', 10596, '5555A0070', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 596, 'A'),
(700597, 100597, 1, 'StockAdjustmentExcel', 'AI', 10597, '5485A0022', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 597, 'A'),
(700598, 100598, 1, 'StockAdjustmentExcel', 'AI', 10598, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 598, 'A'),
(700599, 100599, 1, 'StockAdjustmentExcel', 'AI', 10599, '0367A0101', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 599, 'A'),
(700600, 100600, 1, 'StockAdjustmentExcel', 'AI', 10600, '5508A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 600, 'A'),
(700601, 100601, 1, 'StockAdjustmentExcel', 'AI', 10601, '5508A0224', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 601, 'A'),
(700602, 100602, 1, 'StockAdjustmentExcel', 'AI', 10602, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 602, 'A'),
(700603, 100603, 1, 'StockAdjustmentExcel', 'AI', 10603, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 603, 'A'),
(700604, 100604, 1, 'StockAdjustmentExcel', 'AI', 10604, '5717A0555', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 604, 'A'),
(700605, 100605, 1, 'StockAdjustmentExcel', 'AI', 10605, '5717A0554', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 605, 'A');
INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(700606, 100606, 1, 'StockAdjustmentExcel', 'AI', 10606, '5717A0526', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 606, 'A'),
(700607, 100607, 1, 'StockAdjustmentExcel', 'AI', 10607, '5262A0257/5262A0194/', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 607, 'A'),
(700608, 100608, 1, 'StockAdjustmentExcel', 'AI', 10608, '5552A0372', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 608, 'A'),
(700609, 100609, 1, 'StockAdjustmentExcel', 'AI', 10609, '5924A0134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 609, 'A'),
(700610, 100610, 1, 'StockAdjustmentExcel', 'AI', 10610, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 610, 'A'),
(700611, 100611, 1, 'StockAdjustmentExcel', 'AI', 10611, '5929A0013/5929A0014', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 611, 'A'),
(700612, 100612, 1, 'StockAdjustmentExcel', 'AI', 10612, '5650A0202', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 612, 'A'),
(700613, 100613, 1, 'StockAdjustmentExcel', 'AI', 10613, '5900A1282', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 613, 'A'),
(700614, 100614, 1, 'StockAdjustmentExcel', 'AI', 10614, '5900A1652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 614, 'A'),
(700615, 100615, 1, 'StockAdjustmentExcel', 'AI', 10615, '5508A0192/1043A0389', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 615, 'A'),
(700616, 100616, 1, 'StockAdjustmentExcel', 'AI', 10616, '5929A0027', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 616, 'A'),
(700617, 100617, 1, 'StockAdjustmentExcel', 'AI', 10617, '1156A0041/5495A0106', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 617, 'A'),
(700618, 100618, 1, 'StockAdjustmentExcel', 'AI', 10618, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 618, 'A'),
(700619, 100619, 1, 'StockAdjustmentExcel', 'AI', 10619, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 619, 'A'),
(700620, 100620, 1, 'StockAdjustmentExcel', 'AI', 10620, '1586A0393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 620, 'A'),
(700621, 100621, 1, 'StockAdjustmentExcel', 'AI', 10621, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 621, 'A'),
(700622, 100622, 1, 'StockAdjustmentExcel', 'AI', 10622, '0244A0497', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 622, 'A'),
(700623, 100623, 1, 'StockAdjustmentExcel', 'AI', 10623, '5607Y0038', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 623, 'A'),
(700624, 100624, 1, 'StockAdjustmentExcel', 'AI', 10624, '5607A0153', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 624, 'A'),
(700625, 100625, 1, 'StockAdjustmentExcel', 'AI', 10625, '5607A0477 /5890A0539', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 625, 'A'),
(700626, 100626, 1, 'StockAdjustmentExcel', 'AI', 10626, '5607A1484', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 626, 'A'),
(700627, 100627, 1, 'StockAdjustmentExcel', 'AI', 10627, '1304A0203/5620A1939', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 627, 'A'),
(700628, 100628, 1, 'StockAdjustmentExcel', 'AI', 10628, '5620A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 628, 'A'),
(700629, 100629, 1, 'StockAdjustmentExcel', 'AI', 10629, '5620A0869', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 629, 'A'),
(700630, 100630, 1, 'StockAdjustmentExcel', 'AI', 10630, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 630, 'A'),
(700631, 100631, 1, 'StockAdjustmentExcel', 'AI', 10631, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 631, 'A'),
(700632, 100632, 1, 'StockAdjustmentExcel', 'AI', 10632, '6098A0138', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 632, 'A'),
(700633, 100633, 1, 'StockAdjustmentExcel', 'AI', 10633, '5900A1285', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 633, 'A'),
(700634, 100634, 1, 'StockAdjustmentExcel', 'AI', 10634, '5625A0257', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 634, 'A'),
(700635, 100635, 1, 'StockAdjustmentExcel', 'AI', 10635, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 635, 'A'),
(700636, 100636, 1, 'StockAdjustmentExcel', 'AI', 10636, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 636, 'A'),
(700637, 100637, 1, 'StockAdjustmentExcel', 'AI', 10637, '5620A1687', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 637, 'A'),
(700638, 100638, 1, 'StockAdjustmentExcel', 'AI', 10638, '1304A0200/5620A0873', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 638, 'A'),
(700639, 100639, 1, 'StockAdjustmentExcel', 'AI', 10639, '5870A2846', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 639, 'A'),
(700640, 100640, 1, 'StockAdjustmentExcel', 'AI', 10640, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:36', 'usertool', 20001, 640, 'A'),
(700641, 100641, 1, 'StockAdjustmentExcel', 'AI', 10641, '5512A0054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 641, 'A'),
(700642, 100642, 1, 'StockAdjustmentExcel', 'AI', 10642, '5717A0556', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 642, 'A'),
(700643, 100643, 1, 'StockAdjustmentExcel', 'AI', 10643, '5761A0089/5490A0214', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 643, 'A'),
(700644, 100644, 1, 'StockAdjustmentExcel', 'AI', 10644, '5490A0205', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 644, 'A'),
(700645, 100645, 1, 'StockAdjustmentExcel', 'AI', 10645, '5512A0059', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 645, 'A'),
(700646, 100646, 1, 'StockAdjustmentExcel', 'AI', 10646, '5924A0135', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 646, 'A'),
(700647, 100647, 1, 'StockAdjustmentExcel', 'AI', 10647, '5495A0160/0249A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 647, 'A'),
(700648, 100648, 1, 'StockAdjustmentExcel', 'AI', 10648, '6183A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 648, 'A'),
(700649, 100649, 1, 'StockAdjustmentExcel', 'AI', 10649, '5701A0091', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 649, 'A'),
(700650, 100650, 1, 'StockAdjustmentExcel', 'AI', 10650, '5701A0094', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 650, 'A'),
(700651, 100651, 1, 'StockAdjustmentExcel', 'AI', 10651, '5701A0008', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 651, 'A'),
(700652, 100652, 1, 'StockAdjustmentExcel', 'AI', 10652, '5701A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 652, 'A'),
(700653, 100653, 1, 'StockAdjustmentExcel', 'AI', 10653, '5701A0088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 653, 'A'),
(700654, 100654, 1, 'StockAdjustmentExcel', 'AI', 10654, '5701A0095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 654, 'A'),
(700655, 100655, 1, 'StockAdjustmentExcel', 'AI', 10655, '5701A0092', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 655, 'A'),
(700656, 100656, 1, 'StockAdjustmentExcel', 'AI', 10656, '5701A0096', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 656, 'A'),
(700657, 100657, 1, 'StockAdjustmentExcel', 'AI', 10657, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 657, 'A'),
(700658, 100658, 1, 'StockAdjustmentExcel', 'AI', 10658, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 658, 'A'),
(700659, 100659, 1, 'StockAdjustmentExcel', 'AI', 10659, '5657A0031', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 659, 'A'),
(700660, 100660, 1, 'StockAdjustmentExcel', 'AI', 10660, '0244A0962', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 660, 'A'),
(700661, 100661, 1, 'StockAdjustmentExcel', 'AI', 10661, '0244A0965', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 661, 'A'),
(700662, 100662, 1, 'StockAdjustmentExcel', 'AI', 10662, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 663, 'A'),
(700663, 100663, 1, 'StockAdjustmentExcel', 'AI', 10663, '5900A1449', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 664, 'A'),
(700664, 100664, 1, 'StockAdjustmentExcel', 'AI', 10664, '5900A1501', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 665, 'A'),
(700665, 100665, 1, 'StockAdjustmentExcel', 'AI', 10665, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 666, 'A'),
(700666, 100666, 1, 'StockAdjustmentExcel', 'AI', 10666, '0453A0123', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 667, 'A'),
(700667, 100667, 1, 'StockAdjustmentExcel', 'AI', 10667, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 668, 'A'),
(700668, 100668, 1, 'StockAdjustmentExcel', 'AI', 10668, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 669, 'A'),
(700669, 100669, 1, 'StockAdjustmentExcel', 'AI', 10669, '1156A0041/5495A010', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 670, 'A'),
(700670, 100670, 1, 'StockAdjustmentExcel', 'AI', 10670, '5497A0453', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 671, 'A'),
(700671, 100671, 1, 'StockAdjustmentExcel', 'AI', 10671, '0853A1693', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 672, 'A'),
(700672, 100672, 1, 'StockAdjustmentExcel', 'AI', 10672, '5890A0729', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 673, 'A'),
(700673, 100673, 1, 'StockAdjustmentExcel', 'AI', 10673, '5890A0674/5890A0455', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 674, 'A'),
(700674, 100674, 1, 'StockAdjustmentExcel', 'AI', 10674, '5890A1178', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 675, 'A'),
(700675, 100675, 1, 'StockAdjustmentExcel', 'AI', 10675, '5890A0510/5890A0756', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 676, 'A'),
(700676, 100676, 1, 'StockAdjustmentExcel', 'AI', 10676, '0256A2624', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 677, 'A'),
(700677, 100677, 1, 'StockAdjustmentExcel', 'AI', 10677, '5739A0071', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 678, 'A'),
(700678, 100678, 1, 'StockAdjustmentExcel', 'AI', 10678, '0244A1084', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 679, 'A'),
(700679, 100679, 1, 'StockAdjustmentExcel', 'AI', 10679, '5620A0948', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 680, 'A'),
(700680, 100680, 1, 'StockAdjustmentExcel', 'AI', 10680, '5620A1054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 681, 'A'),
(700681, 100681, 1, 'StockAdjustmentExcel', 'AI', 10681, '5620A1053', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 682, 'A'),
(700682, 100682, 1, 'StockAdjustmentExcel', 'AI', 10682, '5620A2167', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 683, 'A'),
(700683, 100683, 1, 'StockAdjustmentExcel', 'AI', 10683, '5620A2393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 684, 'A'),
(700684, 100684, 1, 'StockAdjustmentExcel', 'AI', 10684, '0711A1034', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 685, 'A'),
(700685, 100685, 1, 'StockAdjustmentExcel', 'AI', 10685, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 686, 'A'),
(700686, 100686, 1, 'StockAdjustmentExcel', 'AI', 10686, '5900A1068', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 687, 'A'),
(700687, 100687, 1, 'StockAdjustmentExcel', 'AI', 10687, '5900A3223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 688, 'A'),
(700688, 100688, 1, 'StockAdjustmentExcel', 'AI', 10688, '5900Y0056', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 689, 'A'),
(700689, 100689, 1, 'StockAdjustmentExcel', 'AI', 10689, '5507A0016', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 690, 'A'),
(700690, 100690, 1, 'StockAdjustmentExcel', 'AI', 10690, '5900A1665', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 691, 'A'),
(700691, 100691, 1, 'StockAdjustmentExcel', 'AI', 10691, '5507A0020', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 692, 'A'),
(700692, 100692, 1, 'StockAdjustmentExcel', 'AI', 10692, '5542A1531', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 693, 'A'),
(700693, 100693, 1, 'StockAdjustmentExcel', 'AI', 10693, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 694, 'A'),
(700694, 100694, 1, 'StockAdjustmentExcel', 'AI', 10694, '5900A2625', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 695, 'A'),
(700695, 100695, 1, 'StockAdjustmentExcel', 'AI', 10695, '5552A0315', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 696, 'A'),
(700696, 100696, 1, 'StockAdjustmentExcel', 'AI', 10696, '5620A0949', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 697, 'A'),
(700697, 100697, 1, 'StockAdjustmentExcel', 'AI', 10697, '5620A2334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 698, 'A'),
(700698, 100698, 1, 'StockAdjustmentExcel', 'AI', 10698, '5620A1051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 699, 'A'),
(700699, 100699, 1, 'StockAdjustmentExcel', 'AI', 10699, '5620A0166', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 700, 'A'),
(700700, 100700, 1, 'StockAdjustmentExcel', 'AI', 10700, '5620A1046', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 701, 'A'),
(700701, 100701, 1, 'StockAdjustmentExcel', 'AI', 10701, '5620A1052', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 702, 'A'),
(700702, 100702, 1, 'StockAdjustmentExcel', 'AI', 10702, '5620A1045', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 703, 'A'),
(700703, 100703, 1, 'StockAdjustmentExcel', 'AI', 10703, '5620A1043', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 704, 'A'),
(700704, 100704, 1, 'StockAdjustmentExcel', 'AI', 10704, '5620A2400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 705, 'A'),
(700705, 100705, 1, 'StockAdjustmentExcel', 'AI', 10705, '5552A0334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 706, 'A'),
(700706, 100706, 1, 'StockAdjustmentExcel', 'AI', 10706, '5669A0006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 707, 'A'),
(700707, 100707, 1, 'StockAdjustmentExcel', 'AI', 10707, '5669A0400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 708, 'A'),
(700708, 100708, 1, 'StockAdjustmentExcel', 'AI', 10708, '5669A0414', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 709, 'A'),
(700709, 100709, 1, 'StockAdjustmentExcel', 'AI', 10709, '5669A0397', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 710, 'A'),
(700710, 100710, 1, 'StockAdjustmentExcel', 'AI', 10710, '5669A0100', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 711, 'A'),
(700711, 100711, 1, 'StockAdjustmentExcel', 'AI', 10711, '5669A0411', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 712, 'A'),
(700712, 100712, 1, 'StockAdjustmentExcel', 'AI', 10712, '5669A0009', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 713, 'A'),
(700713, 100713, 1, 'StockAdjustmentExcel', 'AI', 10713, '5669A0984', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 714, 'A'),
(700714, 100714, 1, 'StockAdjustmentExcel', 'AI', 10714, '1629A0055', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 715, 'A'),
(700715, 100715, 1, 'StockAdjustmentExcel', 'AI', 10715, '0546A4280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 716, 'A'),
(700716, 100716, 1, 'StockAdjustmentExcel', 'AI', 10716, '1430A0273', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 717, 'A'),
(700717, 100717, 1, 'StockAdjustmentExcel', 'AI', 10717, '0961A0250', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 718, 'A'),
(700718, 100718, 1, 'StockAdjustmentExcel', 'AI', 10718, '5625A0269', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 719, 'A'),
(700719, 100719, 1, 'StockAdjustmentExcel', 'AI', 10719, '0545A0308', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 720, 'A'),
(700720, 100720, 1, 'StockAdjustmentExcel', 'AI', 10720, '5900A1485', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 721, 'A'),
(700721, 100721, 1, 'StockAdjustmentExcel', 'AI', 10721, '5924A0681', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 722, 'A'),
(700722, 100722, 1, 'StockAdjustmentExcel', 'AI', 10722, '5900A1176', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 723, 'A'),
(700723, 100723, 1, 'StockAdjustmentExcel', 'AI', 10723, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 724, 'A'),
(700724, 100724, 1, 'StockAdjustmentExcel', 'AI', 10724, '0244A0829', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 725, 'A'),
(700725, 100725, 1, 'StockAdjustmentExcel', 'AI', 10725, '5900A1364', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 726, 'A'),
(700726, 100726, 1, 'StockAdjustmentExcel', 'AI', 10726, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 727, 'A'),
(700727, 100727, 1, 'StockAdjustmentExcel', 'AI', 10727, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 728, 'A'),
(700728, 100728, 1, 'StockAdjustmentExcel', 'AI', 10728, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 729, 'A'),
(700729, 100729, 1, 'StockAdjustmentExcel', 'AI', 10729, '5900A1195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 730, 'A'),
(700730, 100730, 1, 'StockAdjustmentExcel', 'AI', 10730, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 731, 'A'),
(700731, 100731, 1, 'StockAdjustmentExcel', 'AI', 10731, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 732, 'A'),
(700732, 100732, 1, 'StockAdjustmentExcel', 'AI', 10732, '5900A1098', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 733, 'A'),
(700733, 100733, 1, 'StockAdjustmentExcel', 'AI', 10733, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 734, 'A'),
(700734, 100734, 1, 'StockAdjustmentExcel', 'AI', 10734, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 735, 'A'),
(700735, 100735, 1, 'StockAdjustmentExcel', 'AI', 10735, '5900A1093', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 736, 'A'),
(700736, 100736, 1, 'StockAdjustmentExcel', 'AI', 10736, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 737, 'A'),
(700737, 100737, 1, 'StockAdjustmentExcel', 'AI', 10737, '5900A1342', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 738, 'A'),
(700738, 100738, 1, 'StockAdjustmentExcel', 'AI', 10738, '5900A1147', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 739, 'A'),
(700739, 100739, 1, 'StockAdjustmentExcel', 'AI', 10739, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 740, 'A'),
(700740, 100740, 1, 'StockAdjustmentExcel', 'AI', 10740, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 741, 'A'),
(700741, 100741, 1, 'StockAdjustmentExcel', 'AI', 10741, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 742, 'A'),
(700742, 100742, 1, 'StockAdjustmentExcel', 'AI', 10742, '5648A0155', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 743, 'A'),
(700743, 100743, 1, 'StockAdjustmentExcel', 'AI', 10743, '5510A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 744, 'A'),
(700744, 100744, 1, 'StockAdjustmentExcel', 'AI', 10744, '1041A2940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 745, 'A'),
(700745, 100745, 1, 'StockAdjustmentExcel', 'AI', 10745, '1047A1795', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 746, 'A'),
(700746, 100746, 1, 'StockAdjustmentExcel', 'AI', 10746, '5542A0907', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 747, 'A'),
(700747, 100747, 1, 'StockAdjustmentExcel', 'AI', 10747, '5581A0003', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 748, 'A'),
(700748, 100748, 1, 'StockAdjustmentExcel', 'AI', 10748, '0380A0622', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 749, 'A'),
(700749, 100749, 1, 'StockAdjustmentExcel', 'AI', 10749, '5542A1509', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 750, 'A'),
(700750, 100750, 1, 'StockAdjustmentExcel', 'AI', 10750, '5542A0280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 751, 'A'),
(700751, 100751, 1, 'StockAdjustmentExcel', 'AI', 10751, '5620A1095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 752, 'A'),
(700752, 100752, 1, 'StockAdjustmentExcel', 'AI', 10752, '5542A0940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 753, 'A'),
(700753, 100753, 1, 'StockAdjustmentExcel', 'AI', 10753, '5542A0753', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 754, 'A'),
(700754, 100754, 1, 'StockAdjustmentExcel', 'AI', 10754, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 755, 'A'),
(700755, 100755, 1, 'StockAdjustmentExcel', 'AI', 10755, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 756, 'A'),
(700756, 100756, 1, 'StockAdjustmentExcel', 'AI', 10756, '0255A0639', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 757, 'A'),
(700757, 100757, 1, 'StockAdjustmentExcel', 'AI', 10757, '5900A1519', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 758, 'A'),
(700758, 100758, 1, 'StockAdjustmentExcel', 'AI', 10758, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 759, 'A'),
(700759, 100759, 1, 'StockAdjustmentExcel', 'AI', 10759, '5900A1134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 760, 'A'),
(700760, 100760, 1, 'StockAdjustmentExcel', 'AI', 10760, '5900A1395', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 761, 'A'),
(700761, 100761, 1, 'StockAdjustmentExcel', 'AI', 10761, '5900Y0019', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 762, 'A'),
(700762, 100762, 1, 'StockAdjustmentExcel', 'AI', 10762, '5900A2601', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 763, 'A'),
(700763, 100763, 1, 'StockAdjustmentExcel', 'AI', 10763, '5900Y0402', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 764, 'A'),
(700764, 100764, 1, 'StockAdjustmentExcel', 'AI', 10764, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 765, 'A'),
(700765, 100765, 1, 'StockAdjustmentExcel', 'AI', 10765, '5521A0404', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 766, 'A'),
(700766, 100766, 1, 'StockAdjustmentExcel', 'AI', 10766, '5900A1978', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 767, 'A'),
(700767, 100767, 1, 'StockAdjustmentExcel', 'AI', 10767, '5894A0713', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 768, 'A'),
(700768, 100768, 1, 'StockAdjustmentExcel', 'AI', 10768, '1586A0663', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 769, 'A'),
(700769, 100769, 1, 'StockAdjustmentExcel', 'AI', 10769, '5542A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 770, 'A'),
(700770, 100770, 1, 'StockAdjustmentExcel', 'AI', 10770, '1041A2427', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 771, 'A'),
(700771, 100771, 1, 'StockAdjustmentExcel', 'AI', 10771, '5542A1503', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 772, 'A'),
(700772, 100772, 1, 'StockAdjustmentExcel', 'AI', 10772, '1586A0648', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 773, 'A'),
(700773, 100773, 1, 'StockAdjustmentExcel', 'AI', 10773, '1586A0652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 774, 'A'),
(700774, 100774, 1, 'StockAdjustmentExcel', 'AI', 10774, '5900A1451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 775, 'A'),
(700775, 100775, 1, 'StockAdjustmentExcel', 'AI', 10775, '5625A0113', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 776, 'A'),
(700776, 100776, 1, 'StockAdjustmentExcel', 'AI', 10776, '5648A0121', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 777, 'A'),
(700777, 100777, 1, 'StockAdjustmentExcel', 'AI', 10777, '1043A0155', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 778, 'A'),
(700778, 100778, 1, 'StockAdjustmentExcel', 'AI', 10778, '5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 779, 'A'),
(700779, 100779, 1, 'StockAdjustmentExcel', 'AI', 10779, '3274A0019/5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 780, 'A'),
(700780, 100780, 1, 'StockAdjustmentExcel', 'AI', 10780, '5968A0102', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 781, 'A'),
(700781, 100781, 1, 'StockAdjustmentExcel', 'AI', 10781, '5778A3492', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 782, 'A'),
(700782, 100782, 1, 'StockAdjustmentExcel', 'AI', 10782, '1329A0139', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 783, 'A'),
(700783, 100783, 1, 'StockAdjustmentExcel', 'AI', 10783, '5900A0965', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 784, 'A'),
(700784, 100784, 1, 'StockAdjustmentExcel', 'AI', 10784, '5900A0913', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 785, 'A'),
(700785, 100785, 1, 'StockAdjustmentExcel', 'AI', 10785, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 786, 'A'),
(700786, 100786, 1, 'StockAdjustmentExcel', 'AI', 10786, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 787, 'A'),
(700787, 100787, 1, 'StockAdjustmentExcel', 'AI', 10787, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 788, 'A'),
(700788, 100788, 1, 'StockAdjustmentExcel', 'AI', 10788, '5900A2786', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 789, 'A'),
(700789, 100789, 1, 'StockAdjustmentExcel', 'AI', 10789, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 790, 'A'),
(700790, 100790, 1, 'StockAdjustmentExcel', 'AI', 10790, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 791, 'A'),
(700791, 100791, 1, 'StockAdjustmentExcel', 'AI', 10791, '5872A2035 ', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 792, 'A'),
(700792, 100792, 1, 'StockAdjustmentExcel', 'AI', 10792, '5885A0326', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 793, 'A'),
(700793, 100793, 1, 'StockAdjustmentExcel', 'AI', 10793, '5924A0102', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 794, 'A'),
(700794, 100794, 1, 'StockAdjustmentExcel', 'AI', 10794, '5557A0037', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 795, 'A'),
(700795, 100795, 1, 'StockAdjustmentExcel', 'AI', 10795, '5924A0074', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 796, 'A'),
(700796, 100796, 1, 'StockAdjustmentExcel', 'AI', 10796, '5924A0116', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 797, 'A'),
(700797, 100797, 1, 'StockAdjustmentExcel', 'AI', 10797, '5929A0008', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 798, 'A'),
(700798, 100798, 1, 'StockAdjustmentExcel', 'AI', 10798, '6045A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 799, 'A'),
(700799, 100799, 1, 'StockAdjustmentExcel', 'AI', 10799, '5956A0521', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 800, 'A'),
(700800, 100800, 1, 'StockAdjustmentExcel', 'AI', 10800, '5929A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 801, 'A'),
(700801, 100801, 1, 'StockAdjustmentExcel', 'AI', 10801, '6098A0167/5625A0327', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 802, 'A'),
(700802, 100802, 1, 'StockAdjustmentExcel', 'AI', 10802, '5900A1091', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 803, 'A');
INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(700803, 100803, 1, 'StockAdjustmentExcel', 'AI', 10803, '5924A0081', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 804, 'A'),
(700804, 100804, 1, 'StockAdjustmentExcel', 'AI', 10804, '5924A0083', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 805, 'A'),
(700805, 100805, 1, 'StockAdjustmentExcel', 'AI', 10805, '5924A0082', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 806, 'A'),
(700806, 100806, 1, 'StockAdjustmentExcel', 'AI', 10806, '5924A0102', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 807, 'A'),
(700807, 100807, 1, 'StockAdjustmentExcel', 'AI', 10807, '5540A1233 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 808, 'A'),
(700808, 100808, 1, 'StockAdjustmentExcel', 'AI', 10808, '5620A1877 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 809, 'A'),
(700809, 100809, 1, 'StockAdjustmentExcel', 'AI', 10809, '6045A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 810, 'A'),
(700810, 100810, 1, 'StockAdjustmentExcel', 'AI', 10810, '6045A0002', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 811, 'A'),
(700811, 100811, 1, 'StockAdjustmentExcel', 'AI', 10811, '5956A0522', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 812, 'A'),
(700812, 100812, 1, 'StockAdjustmentExcel', 'AI', 10812, '6045A0001', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 813, 'A'),
(700813, 100813, 1, 'StockAdjustmentExcel', 'AI', 10813, '6045A0002', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 814, 'A'),
(700814, 100814, 1, 'StockAdjustmentExcel', 'AI', 10814, '5717A0690', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 815, 'A'),
(700815, 100815, 1, 'StockAdjustmentExcel', 'AI', 10815, '5717A0518', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 816, 'A'),
(700816, 100816, 1, 'StockAdjustmentExcel', 'AI', 10816, '5717A0517', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 817, 'A'),
(700817, 100817, 1, 'StockAdjustmentExcel', 'AI', 10817, '6045A0172', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 818, 'A'),
(700818, 100818, 1, 'StockAdjustmentExcel', 'AI', 10818, '5717A0699', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 819, 'A'),
(700819, 100819, 1, 'StockAdjustmentExcel', 'AI', 10819, '6045A0136', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 820, 'A'),
(700820, 100820, 1, 'StockAdjustmentExcel', 'AI', 10820, '6045A0146', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 821, 'A'),
(700821, 100821, 1, 'StockAdjustmentExcel', 'AI', 10821, '6045A0143', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 822, 'A'),
(700822, 100822, 1, 'StockAdjustmentExcel', 'AI', 10822, '5924A0173', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 823, 'A'),
(700823, 100823, 1, 'StockAdjustmentExcel', 'AI', 10823, '5924A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 824, 'A'),
(700824, 100824, 1, 'StockAdjustmentExcel', 'AI', 10824, '5924A0171', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 825, 'A'),
(700825, 100825, 1, 'StockAdjustmentExcel', 'AI', 10825, '5613A0187', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 826, 'A'),
(700826, 100826, 1, 'StockAdjustmentExcel', 'AI', 10826, '5613A0186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 827, 'A'),
(700827, 100827, 1, 'StockAdjustmentExcel', 'AI', 10827, '5924A0164', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 828, 'A'),
(700828, 100828, 1, 'StockAdjustmentExcel', 'AI', 10828, '5613A0245', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 829, 'A'),
(700829, 100829, 1, 'StockAdjustmentExcel', 'AI', 10829, '5929A0009', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 830, 'A'),
(700830, 100830, 1, 'StockAdjustmentExcel', 'AI', 10830, '5625A0325', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 831, 'A'),
(700831, 100831, 1, 'StockAdjustmentExcel', 'AI', 10831, '5924A0118', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 832, 'A'),
(700832, 100832, 1, 'StockAdjustmentExcel', 'AI', 10832, '5924A0142', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 833, 'A'),
(700833, 100833, 1, 'StockAdjustmentExcel', 'AI', 10833, '5523A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 834, 'A'),
(700834, 100834, 1, 'StockAdjustmentExcel', 'AI', 10834, '5924A0119', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:37', 'usertool', 20001, 835, 'A'),
(700835, 100835, 1, 'StockAdjustmentExcel', 'AI', 10835, '5508A0140', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 836, 'A'),
(700836, 100836, 1, 'StockAdjustmentExcel', 'AI', 10836, '5872A2035', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 837, 'A'),
(700837, 100837, 1, 'StockAdjustmentExcel', 'AI', 10837, '5924A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 838, 'A'),
(700838, 100838, 1, 'StockAdjustmentExcel', 'AI', 10838, '5045A0008', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 839, 'A'),
(700839, 100839, 1, 'StockAdjustmentExcel', 'AI', 10839, '5924A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 840, 'A'),
(700840, 100840, 1, 'StockAdjustmentExcel', 'AI', 10840, '5700A0852', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 841, 'A'),
(700841, 100841, 1, 'StockAdjustmentExcel', 'AI', 10841, '5620A2284', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 842, 'A'),
(700842, 100842, 1, 'StockAdjustmentExcel', 'AI', 10842, '5508A0269', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 843, 'A'),
(700843, 100843, 1, 'StockAdjustmentExcel', 'AI', 10843, '5540A1431', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 844, 'A'),
(700844, 100844, 1, 'StockAdjustmentExcel', 'AI', 10844, '5540A1432', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 845, 'A'),
(700845, 100845, 1, 'StockAdjustmentExcel', 'AI', 10845, '5540A1370', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 846, 'A'),
(700846, 100846, 1, 'StockAdjustmentExcel', 'AI', 10846, '5540A1368', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 847, 'A'),
(700847, 100847, 1, 'StockAdjustmentExcel', 'AI', 10847, '5540A1233', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 848, 'A'),
(700848, 100848, 1, 'StockAdjustmentExcel', 'AI', 10848, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 849, 'A'),
(700849, 100849, 1, 'StockAdjustmentExcel', 'AI', 10849, '5542A0932', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 850, 'A'),
(700850, 100850, 1, 'StockAdjustmentExcel', 'AI', 10850, '5620A0409', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 851, 'A'),
(700851, 100851, 1, 'StockAdjustmentExcel', 'AI', 10851, '5542A1218', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 852, 'A'),
(700852, 100852, 1, 'StockAdjustmentExcel', 'AI', 10852, '5557A0037', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 853, 'A'),
(700853, 100853, 1, 'StockAdjustmentExcel', 'AI', 10853, '5700A0853', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 854, 'A'),
(700854, 100854, 1, 'StockAdjustmentExcel', 'AI', 10854, '5700A0869', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 855, 'A'),
(700855, 100855, 1, 'StockAdjustmentExcel', 'AI', 10855, '5700A0870', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 856, 'A'),
(700856, 100856, 1, 'StockAdjustmentExcel', 'AI', 10856, '5700A0871', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 857, 'A'),
(700857, 100857, 1, 'StockAdjustmentExcel', 'AI', 10857, '6045A0145', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 858, 'A'),
(700858, 100858, 1, 'StockAdjustmentExcel', 'AI', 10858, '5508A0249', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 859, 'A'),
(700859, 100859, 1, 'StockAdjustmentExcel', 'AI', 10859, '5700A0854', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 860, 'A'),
(700860, 100860, 1, 'StockAdjustmentExcel', 'AI', 10860, '5924A0317', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 861, 'A'),
(700861, 100861, 1, 'StockAdjustmentExcel', 'AI', 10861, '5872A2197', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 862, 'A'),
(700862, 100862, 1, 'StockAdjustmentExcel', 'AI', 10862, '5924A0316', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 863, 'A'),
(700863, 100863, 1, 'StockAdjustmentExcel', 'AI', 10863, '5924A0318', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 864, 'A'),
(700864, 100864, 1, 'StockAdjustmentExcel', 'AI', 10864, '5540A1370', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 865, 'A'),
(700865, 100865, 1, 'StockAdjustmentExcel', 'AI', 10865, '5540A1368', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 866, 'A'),
(700866, 100866, 1, 'StockAdjustmentExcel', 'AI', 10866, '5924A0283', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 867, 'A'),
(700867, 100867, 1, 'StockAdjustmentExcel', 'AI', 10867, '5900A1208', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 868, 'A'),
(700868, 100868, 1, 'StockAdjustmentExcel', 'AI', 10868, '5885A0289', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 869, 'A'),
(700869, 100869, 1, 'StockAdjustmentExcel', 'AI', 10869, '5613A0187', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 870, 'A'),
(700870, 100870, 1, 'StockAdjustmentExcel', 'AI', 10870, '5613A0186', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 871, 'A'),
(700871, 100871, 1, 'StockAdjustmentExcel', 'AI', 10871, '6098A0168', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 872, 'A'),
(700872, 100872, 1, 'StockAdjustmentExcel', 'AI', 10872, '5929A0003', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 873, 'A'),
(700873, 100873, 1, 'StockAdjustmentExcel', 'AI', 10873, '5924A0077', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 874, 'A'),
(700874, 100874, 1, 'StockAdjustmentExcel', 'AI', 10874, '5507A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 875, 'A'),
(700875, 100875, 1, 'StockAdjustmentExcel', 'AI', 10875, '5507A0036', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 876, 'A'),
(700876, 100876, 1, 'StockAdjustmentExcel', 'AI', 10876, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 877, 'A'),
(700877, 100877, 1, 'StockAdjustmentExcel', 'AI', 10877, '5924A0123', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 878, 'A'),
(700878, 100878, 1, 'StockAdjustmentExcel', 'AI', 10878, '5625A0430', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 879, 'A'),
(700879, 100879, 1, 'StockAdjustmentExcel', 'AI', 10879, '5900A1968', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 880, 'A'),
(700880, 100880, 1, 'StockAdjustmentExcel', 'AI', 10880, '5520A0435', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 881, 'A'),
(700881, 100881, 1, 'StockAdjustmentExcel', 'AI', 10881, '5495A0123', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 882, 'A'),
(700882, 100882, 1, 'StockAdjustmentExcel', 'AI', 10882, '5872A2035 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 883, 'A'),
(700883, 100883, 1, 'StockAdjustmentExcel', 'AI', 10883, '6183A0015', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 884, 'A'),
(700884, 100884, 1, 'StockAdjustmentExcel', 'AI', 10884, '5964A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 885, 'A'),
(700885, 100885, 1, 'StockAdjustmentExcel', 'AI', 10885, '0958A1983', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 886, 'A'),
(700886, 100886, 1, 'StockAdjustmentExcel', 'AI', 10886, '5540A1431', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 887, 'A'),
(700887, 100887, 1, 'StockAdjustmentExcel', 'AI', 10887, '5700A0882', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 888, 'A'),
(700888, 100888, 1, 'StockAdjustmentExcel', 'AI', 10888, '5717A0518', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 889, 'A'),
(700889, 100889, 1, 'StockAdjustmentExcel', 'AI', 10889, '6045A0189', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 890, 'A'),
(700890, 100890, 1, 'StockAdjustmentExcel', 'AI', 10890, '5717A0699', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 891, 'A'),
(700891, 100891, 1, 'StockAdjustmentExcel', 'AI', 10891, '6098A0125', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 892, 'A'),
(700892, 100892, 1, 'StockAdjustmentExcel', 'AI', 10892, '5717A0517', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 893, 'A'),
(700893, 100893, 1, 'StockAdjustmentExcel', 'AI', 10893, '5717A0690', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 894, 'A'),
(700894, 100894, 1, 'StockAdjustmentExcel', 'AI', 10894, '5542A0014', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 895, 'A'),
(700895, 100895, 1, 'StockAdjustmentExcel', 'AI', 10895, '6045A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 896, 'A'),
(700896, 100896, 1, 'StockAdjustmentExcel', 'AI', 10896, '5090A0029', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 897, 'A'),
(700897, 100897, 1, 'StockAdjustmentExcel', 'AI', 10897, '5717A0699', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 898, 'A'),
(700898, 100898, 1, 'StockAdjustmentExcel', 'AI', 10898, '6045A0172', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 899, 'A'),
(700899, 100899, 1, 'StockAdjustmentExcel', 'AI', 10899, '5717A0517', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 900, 'A'),
(700900, 100900, 1, 'StockAdjustmentExcel', 'AI', 10900, '5717A0690', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 901, 'A'),
(700901, 100901, 1, 'StockAdjustmentExcel', 'AI', 10901, '5557A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 902, 'A'),
(700902, 100902, 1, 'StockAdjustmentExcel', 'AI', 10902, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 903, 'A'),
(700903, 100903, 1, 'StockAdjustmentExcel', 'AI', 10903, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 904, 'A'),
(700904, 100904, 1, 'StockAdjustmentExcel', 'AI', 10904, '5924A0074', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 905, 'A'),
(700905, 100905, 1, 'StockAdjustmentExcel', 'AI', 10905, '5900A2021', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 906, 'A'),
(700906, 100906, 1, 'StockAdjustmentExcel', 'AI', 10906, '5900A2026', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 907, 'A'),
(700907, 100907, 1, 'StockAdjustmentExcel', 'AI', 10907, '5900A1229', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 908, 'A'),
(700908, 100908, 1, 'StockAdjustmentExcel', 'AI', 10908, '5924A0081', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 909, 'A'),
(700909, 100909, 1, 'StockAdjustmentExcel', 'AI', 10909, '5924A0083', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 910, 'A'),
(700910, 100910, 1, 'StockAdjustmentExcel', 'AI', 10910, '5924A0102', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 911, 'A'),
(700911, 100911, 1, 'StockAdjustmentExcel', 'AI', 10911, '5924A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 912, 'A'),
(700912, 100912, 1, 'StockAdjustmentExcel', 'AI', 10912, '5924A0079', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 913, 'A'),
(700913, 100913, 1, 'StockAdjustmentExcel', 'AI', 10913, '5929A0003', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 914, 'A'),
(700914, 100914, 1, 'StockAdjustmentExcel', 'AI', 10914, '5924A0111', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 915, 'A'),
(700915, 100915, 1, 'StockAdjustmentExcel', 'AI', 10915, '5929A0012', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 916, 'A'),
(700916, 100916, 1, 'StockAdjustmentExcel', 'AI', 10916, '5924A0125', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 917, 'A'),
(700917, 100917, 1, 'StockAdjustmentExcel', 'AI', 10917, '5924A0213', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 918, 'A'),
(700918, 100918, 1, 'StockAdjustmentExcel', 'AI', 10918, '5924A0216', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 919, 'A'),
(700919, 100919, 1, 'StockAdjustmentExcel', 'AI', 10919, '5924A0215', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 920, 'A'),
(700920, 100920, 1, 'StockAdjustmentExcel', 'AI', 10920, '5924A0077', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 921, 'A'),
(700921, 100921, 1, 'StockAdjustmentExcel', 'AI', 10921, '5929A0004', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 922, 'A'),
(700922, 100922, 1, 'StockAdjustmentExcel', 'AI', 10922, '5924A0074', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 923, 'A'),
(700923, 100923, 1, 'StockAdjustmentExcel', 'AI', 10923, '5900A1091', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 924, 'A'),
(700924, 100924, 1, 'StockAdjustmentExcel', 'AI', 10924, '0958A1983', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 925, 'A'),
(700925, 100925, 1, 'StockAdjustmentExcel', 'AI', 10925, '5495A0205', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 926, 'A'),
(700926, 100926, 1, 'StockAdjustmentExcel', 'AI', 10926, '5508A0319', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 927, 'A'),
(700927, 100927, 1, 'StockAdjustmentExcel', 'AI', 10927, '5520A0434', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 928, 'A'),
(700928, 100928, 1, 'StockAdjustmentExcel', 'AI', 10928, '5924A0636', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 929, 'A'),
(700929, 100929, 1, 'StockAdjustmentExcel', 'AI', 10929, '5956A0990', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 930, 'A'),
(700930, 100930, 1, 'StockAdjustmentExcel', 'AI', 10930, '5872A2054', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 931, 'A'),
(700931, 100931, 1, 'StockAdjustmentExcel', 'AI', 10931, '5273A0273', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 932, 'A'),
(700932, 100932, 1, 'StockAdjustmentExcel', 'AI', 10932, '5964A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 933, 'A'),
(700933, 100933, 1, 'StockAdjustmentExcel', 'AI', 10933, '5613A0359', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 934, 'A'),
(700934, 100934, 1, 'StockAdjustmentExcel', 'AI', 10934, '5625A0326', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 935, 'A'),
(700935, 100935, 1, 'StockAdjustmentExcel', 'AI', 10935, '5700A0854', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 936, 'A'),
(700936, 100936, 1, 'StockAdjustmentExcel', 'AI', 10936, '5607A0666', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 937, 'A'),
(700937, 100937, 1, 'StockAdjustmentExcel', 'AI', 10937, '5620A1667', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 938, 'A'),
(700938, 100938, 1, 'StockAdjustmentExcel', 'AI', 10938, '5620A1768', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 939, 'A'),
(700939, 100939, 1, 'StockAdjustmentExcel', 'AI', 10939, '5620A1787', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 940, 'A'),
(700940, 100940, 1, 'StockAdjustmentExcel', 'AI', 10940, '5620A2521', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 941, 'A'),
(700941, 100941, 1, 'StockAdjustmentExcel', 'AI', 10941, '5620A1788', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 942, 'A'),
(700942, 100942, 1, 'StockAdjustmentExcel', 'AI', 10942, '5620A1773', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 943, 'A'),
(700943, 100943, 1, 'StockAdjustmentExcel', 'AI', 10943, '5620A1314', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 944, 'A'),
(700944, 100944, 1, 'StockAdjustmentExcel', 'AI', 10944, '5620A2566', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 945, 'A'),
(700945, 100945, 1, 'StockAdjustmentExcel', 'AI', 10945, '5956A0522', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 946, 'A'),
(700946, 100946, 1, 'StockAdjustmentExcel', 'AI', 10946, '5885A0289', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 947, 'A'),
(700947, 100947, 1, 'StockAdjustmentExcel', 'AI', 10947, '5613A0186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 948, 'A'),
(700948, 100948, 1, 'StockAdjustmentExcel', 'AI', 10948, '5613A0187', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 949, 'A'),
(700949, 100949, 1, 'StockAdjustmentExcel', 'AI', 10949, '5700A0812', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 950, 'A'),
(700950, 100950, 1, 'StockAdjustmentExcel', 'AI', 10950, '5700A0854', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 951, 'A'),
(700951, 100951, 1, 'StockAdjustmentExcel', 'AI', 10951, '5700A0881', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 952, 'A'),
(700952, 100952, 1, 'StockAdjustmentExcel', 'AI', 10952, '5700A0882', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 953, 'A'),
(700953, 100953, 1, 'StockAdjustmentExcel', 'AI', 10953, '5700A0885', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 954, 'A'),
(700954, 100954, 1, 'StockAdjustmentExcel', 'AI', 10954, '6045A0189', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 955, 'A'),
(700955, 100955, 1, 'StockAdjustmentExcel', 'AI', 10955, '5956A0990', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 956, 'A'),
(700956, 100956, 1, 'StockAdjustmentExcel', 'AI', 10956, '6045A0191', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 957, 'A'),
(700957, 100957, 1, 'StockAdjustmentExcel', 'AI', 10957, '5872A2054', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 958, 'A'),
(700958, 100958, 1, 'StockAdjustmentExcel', 'AI', 10958, '1043A0439', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 959, 'A'),
(700959, 100959, 1, 'StockAdjustmentExcel', 'AI', 10959, '5580A1885', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 960, 'A'),
(700960, 100960, 1, 'StockAdjustmentExcel', 'AI', 10960, '5964A0142', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 961, 'A'),
(700961, 100961, 1, 'StockAdjustmentExcel', 'AI', 10961, '5620A1686', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 962, 'A'),
(700962, 100962, 1, 'StockAdjustmentExcel', 'AI', 10962, '5620A0362', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 963, 'A'),
(700963, 100963, 1, 'StockAdjustmentExcel', 'AI', 10963, '5620A1753', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 964, 'A'),
(700964, 100964, 1, 'StockAdjustmentExcel', 'AI', 10964, '5620A0463', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 965, 'A'),
(700965, 100965, 1, 'StockAdjustmentExcel', 'AI', 10965, '5620A0491', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 966, 'A'),
(700966, 100966, 1, 'StockAdjustmentExcel', 'AI', 10966, '5620A0436', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 967, 'A'),
(700967, 100967, 1, 'StockAdjustmentExcel', 'AI', 10967, '5918A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 968, 'A'),
(700968, 100968, 1, 'StockAdjustmentExcel', 'AI', 10968, '5900A3800', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 969, 'A'),
(700969, 100969, 1, 'StockAdjustmentExcel', 'AI', 10969, '5700A0017', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 970, 'A'),
(700970, 100970, 1, 'StockAdjustmentExcel', 'AI', 10970, '5620A0250', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 971, 'A'),
(700971, 100971, 1, 'StockAdjustmentExcel', 'AI', 10971, '5620A0497', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 972, 'A'),
(700972, 100972, 1, 'StockAdjustmentExcel', 'AI', 10972, '5620A1183', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 973, 'A'),
(700973, 100973, 1, 'StockAdjustmentExcel', 'AI', 10973, '5620A2117', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 974, 'A'),
(700974, 100974, 1, 'StockAdjustmentExcel', 'AI', 10974, '5620A1468', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 975, 'A'),
(700975, 100975, 1, 'StockAdjustmentExcel', 'AI', 10975, '5620A0436', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 976, 'A'),
(700976, 100976, 1, 'StockAdjustmentExcel', 'AI', 10976, '5620A0986', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 977, 'A'),
(700977, 100977, 1, 'StockAdjustmentExcel', 'AI', 10977, '5620A1763', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 978, 'A'),
(700978, 100978, 1, 'StockAdjustmentExcel', 'AI', 10978, '5620A0250', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 979, 'A'),
(700979, 100979, 1, 'StockAdjustmentExcel', 'AI', 10979, '5620A0890', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 980, 'A'),
(700980, 100980, 1, 'StockAdjustmentExcel', 'AI', 10980, '5620A2019 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 981, 'A'),
(700981, 100981, 1, 'StockAdjustmentExcel', 'AI', 10981, '5620A0532', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 982, 'A'),
(700982, 100982, 1, 'StockAdjustmentExcel', 'AI', 10982, '5620A0873', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 983, 'A'),
(700983, 100983, 1, 'StockAdjustmentExcel', 'AI', 10983, '5620A0987', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 984, 'A'),
(700984, 100984, 1, 'StockAdjustmentExcel', 'AI', 10984, '5669A0018', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 985, 'A'),
(700985, 100985, 1, 'StockAdjustmentExcel', 'AI', 10985, '5669A0396', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 986, 'A'),
(700986, 100986, 1, 'StockAdjustmentExcel', 'AI', 10986, '5669A0417', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 987, 'A'),
(700987, 100987, 1, 'StockAdjustmentExcel', 'AI', 10987, '5669A0985', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 988, 'A'),
(700988, 100988, 1, 'StockAdjustmentExcel', 'AI', 10988, '5669A0201', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 989, 'A'),
(700989, 100989, 1, 'StockAdjustmentExcel', 'AI', 10989, '5669A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 990, 'A'),
(700990, 100990, 1, 'StockAdjustmentExcel', 'AI', 10990, '5262A0199', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 991, 'A'),
(700991, 100991, 1, 'StockAdjustmentExcel', 'AI', 10991, '5540A0382', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 992, 'A'),
(700992, 100992, 1, 'StockAdjustmentExcel', 'AI', 10992, '5620A2214', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 993, 'A'),
(700993, 100993, 1, 'StockAdjustmentExcel', 'AI', 10993, '5620A1644', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 994, 'A'),
(700994, 100994, 1, 'StockAdjustmentExcel', 'AI', 10994, '5620A2019', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 995, 'A'),
(700995, 100995, 1, 'StockAdjustmentExcel', 'AI', 10995, '5620A2086', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 996, 'A'),
(700996, 100996, 1, 'StockAdjustmentExcel', 'AI', 10996, '5620A1945', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 997, 'A'),
(700997, 100997, 1, 'StockAdjustmentExcel', 'AI', 10997, '5620A1937', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 998, 'A'),
(700998, 100998, 1, 'StockAdjustmentExcel', 'AI', 10998, '5620A2210', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 999, 'A'),
(700999, 100999, 1, 'StockAdjustmentExcel', 'AI', 10999, '5623A1186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1000, 'A'),
(701000, 101000, 1, 'StockAdjustmentExcel', 'AI', 11000, '5620A2042', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1001, 'A');
INSERT INTO `t_stock` (`id`, `skid`, `sl`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `loc`, `sloc`, `ssloc`, `make`, `uom`, `qty`, `critical`, `tloc`, `issueto`, `takenby`, `rem`, `dt`, `cdt`, `cby`, `spid`, `spsl`, `sts`) VALUES
(701001, 101001, 1, 'StockAdjustmentExcel', 'AI', 11001, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1002, 'A'),
(701002, 101002, 1, 'StockAdjustmentExcel', 'AI', 11002, '6098A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1003, 'A'),
(701003, 101003, 1, 'StockAdjustmentExcel', 'AI', 11003, '6183A0050', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1004, 'A'),
(701004, 101004, 1, 'StockAdjustmentExcel', 'AI', 11004, '5540A1233', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1005, 'A'),
(701005, 101005, 1, 'StockAdjustmentExcel', 'AI', 11005, '0517A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1006, 'A'),
(701006, 101006, 1, 'StockAdjustmentExcel', 'AI', 11006, '0517A0422', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1007, 'A'),
(701007, 101007, 1, 'StockAdjustmentExcel', 'AI', 11007, '5700A0885', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1008, 'A'),
(701008, 101008, 1, 'StockAdjustmentExcel', 'AI', 11008, '5508A0942', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1009, 'A'),
(701009, 101009, 1, 'StockAdjustmentExcel', 'AI', 11009, '5580A0941', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1010, 'A'),
(701010, 101010, 1, 'StockAdjustmentExcel', 'AI', 11010, '6098A0533', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1011, 'A'),
(701011, 101011, 1, 'StockAdjustmentExcel', 'AI', 11011, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1012, 'A'),
(701012, 101012, 1, 'StockAdjustmentExcel', 'AI', 11012, '5620A1818', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1013, 'A'),
(701013, 101013, 1, 'StockAdjustmentExcel', 'AI', 11013, '5620A0898', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1014, 'A'),
(701014, 101014, 1, 'StockAdjustmentExcel', 'AI', 11014, '5620A0429', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1015, 'A'),
(701015, 101015, 1, 'StockAdjustmentExcel', 'AI', 11015, '5620A2571', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1016, 'A'),
(701016, 101016, 1, 'StockAdjustmentExcel', 'AI', 11016, '5620A1754', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1017, 'A'),
(701017, 101017, 1, 'StockAdjustmentExcel', 'AI', 11017, '5620A1466', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'm', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1018, 'A'),
(701018, 101018, 1, 'StockAdjustmentExcel', 'AI', 11018, '5584A0031', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1019, 'A'),
(701019, 101019, 1, 'StockAdjustmentExcel', 'AI', 11019, '5384A0013', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:38', 'usertool', 20001, 1020, 'A'),
(701020, 101020, 1, 'StockAdjustmentExcel', 'AI', 11020, '5623A1186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1021, 'A'),
(701021, 101021, 1, 'StockAdjustmentExcel', 'AI', 11021, '5607A0190', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1022, 'A'),
(701022, 101022, 1, 'StockAdjustmentExcel', 'AI', 11022, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1023, 'A'),
(701023, 101023, 1, 'StockAdjustmentExcel', 'AI', 11023, '0485A0740', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1024, 'A'),
(701024, 101024, 1, 'StockAdjustmentExcel', 'AI', 11024, '5542A1911/ 5620A2393', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1025, 'A'),
(701025, 101025, 1, 'StockAdjustmentExcel', 'AI', 11025, '5620A2351', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1026, 'A'),
(701026, 101026, 1, 'StockAdjustmentExcel', 'AI', 11026, '5620A1045', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1027, 'A'),
(701027, 101027, 1, 'StockAdjustmentExcel', 'AI', 11027, '5620A2334', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1028, 'A'),
(701028, 101028, 1, 'StockAdjustmentExcel', 'AI', 11028, '5620A1927', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1029, 'A'),
(701029, 101029, 1, 'StockAdjustmentExcel', 'AI', 11029, '5620A2426', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1030, 'A'),
(701030, 101030, 1, 'StockAdjustmentExcel', 'AI', 11030, '5620A1821', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1031, 'A'),
(701031, 101031, 1, 'StockAdjustmentExcel', 'AI', 11031, '5620A2879', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1032, 'A'),
(701032, 101032, 1, 'StockAdjustmentExcel', 'AI', 11032, '5900A2794', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1033, 'A'),
(701033, 101033, 1, 'StockAdjustmentExcel', 'AI', 11033, '5900A2001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1034, 'A'),
(701034, 101034, 1, 'StockAdjustmentExcel', 'AI', 11034, '5900A3910', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1035, 'A'),
(701035, 101035, 1, 'StockAdjustmentExcel', 'AI', 11035, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1036, 'A'),
(701036, 101036, 1, 'StockAdjustmentExcel', 'AI', 11036, '5900A2832', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1037, 'A'),
(701037, 101037, 1, 'StockAdjustmentExcel', 'AI', 11037, '5900A1922', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1038, 'A'),
(701038, 101038, 1, 'StockAdjustmentExcel', 'AI', 11038, '5900A2125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1039, 'A'),
(701039, 101039, 1, 'StockAdjustmentExcel', 'AI', 11039, '5900A2145', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1040, 'A'),
(701040, 101040, 1, 'StockAdjustmentExcel', 'AI', 11040, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1041, 'A'),
(701041, 101041, 1, 'StockAdjustmentExcel', 'AI', 11041, '5900A3995', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1042, 'A'),
(701042, 101042, 1, 'StockAdjustmentExcel', 'AI', 11042, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1043, 'A'),
(701043, 101043, 1, 'StockAdjustmentExcel', 'AI', 11043, '5900A1322', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1044, 'A'),
(701044, 101044, 1, 'StockAdjustmentExcel', 'AI', 11044, '5900A2103', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1045, 'A'),
(701045, 101045, 1, 'StockAdjustmentExcel', 'AI', 11045, '5900A2059', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1046, 'A'),
(701046, 101046, 1, 'StockAdjustmentExcel', 'AI', 11046, '5507A0103', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1047, 'A'),
(701047, 101047, 1, 'StockAdjustmentExcel', 'AI', 11047, '5507A0104', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1048, 'A'),
(701048, 101048, 1, 'StockAdjustmentExcel', 'AI', 11048, '5885A0036', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1049, 'A'),
(701049, 101049, 1, 'StockAdjustmentExcel', 'AI', 11049, '5047A0088', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1050, 'A'),
(701050, 101050, 1, 'StockAdjustmentExcel', 'AI', 11050, '5872A2035 ', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1051, 'A'),
(701051, 101051, 1, 'StockAdjustmentExcel', 'AI', 11051, '5607A0699', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1052, 'A'),
(701052, 101052, 1, 'StockAdjustmentExcel', 'AI', 11052, '5900A4017', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1053, 'A'),
(701053, 101053, 1, 'StockAdjustmentExcel', 'AI', 11053, '5956A3994', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1054, 'A'),
(701054, 101054, 1, 'StockAdjustmentExcel', 'AI', 11054, '5540A1811', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1055, 'A'),
(701055, 101055, 1, 'StockAdjustmentExcel', 'AI', 11055, '5956A4131', '2 BY 2', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', '', NULL, NULL, NULL, '2024-02-29 00:00:00', '2024-03-21 14:55:39', 'usertool', 20001, 1056, 'A'),
(701056, 100003, 2, 'StockIN', 'SI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 33, 'N', NULL, NULL, NULL, NULL, '2024-03-28 00:00:00', '2024-03-28 12:09:36', 'usertool', 20002, 1, 'A'),
(701057, 100002, 2, 'StockIN', 'SI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 20, 'N', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:01:14', 'usertool', 20003, 1, 'A'),
(701058, 100002, 3, 'StockOUT', 'SO', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 10, 'N', NULL, '116454 : ARUN KUMAR GUPTA', 'RS10001 : ARUN KUMAR GUPTA', NULL, '2024-04-13 00:00:00', '2024-04-13 10:02:20', 'usertool', 20004, 1, 'A'),
(701059, 100003, 3, 'StockOUT', 'SO', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', NULL, '116454 : ARUN KUMAR GUPTA', 'RS10001 : ARUN KUMAR GUPTA', NULL, '2024-04-13 00:00:00', '2024-04-13 10:03:07', 'usertool', 20005, 1, 'A'),
(701060, 101056, 1, 'StockAdjustment', 'AI', 11056, '', 'TEST MATERIAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-04-13 10:05:41', '2024-04-13 10:05:41', 'usertool', 20006, 1, 'A'),
(701061, 101057, 1, 'StockAdjustment', 'AI', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', '', '', '', 'NOS', 0, 'Y', NULL, NULL, NULL, NULL, '2024-04-13 10:06:29', '2024-04-13 10:06:29', 'usertool', 20007, 1, 'A'),
(701062, 101056, 2, 'StockIN', 'SI', 11056, '', 'TEST MATERIAL', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', NULL, NULL, NULL, NULL, '2024-04-11 00:00:00', '2024-04-13 10:12:40', 'usertool', 20008, 1, 'A'),
(701063, 101057, 2, 'StockIN', 'SI', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', '', '', '', 'NOS', 10, 'Y', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:13:58', 'usertool', 20009, 1, 'A'),
(701064, 101056, 3, 'StockOUT', 'SO', 11056, '', 'TEST MATERIAL', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', NULL, '116291 : MOHAN PRASAD', '116291 : MOHAN PRASAD', NULL, '2024-04-12 00:00:00', '2024-04-13 10:15:48', 'usertool', 20010, 1, 'A'),
(701065, 101057, 3, 'StockTransfer', 'TO', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', '', '', '', 'NOS', 2, 'Y', 'Vessel', NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:18:49', 'Vessel User', 20011, 1, 'A'),
(701066, 101058, 1, 'StockTransfer', 'TI', 11057, '', 'TEST MATERIAL CRIT', 'Vessel', '', '', '', 'NOS', 2, 'Y', 'Toolkit Store', NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:18:49', 'Vessel User', 20011, 1, 'A'),
(701067, 101057, 4, 'InternalMovement', 'TO', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', '', '', '', 'NOS', 3, 'Y', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:21:16', 'usertool', 20012, 1, 'A'),
(701068, 101059, 1, 'InternalMovement', 'TI', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', 'TEST SUB LOC', 'RACK TEST', '', 'NOS', 3, 'Y', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:21:16', 'usertool', 20012, 1, 'A'),
(701069, 101059, 2, 'StockOUT', 'SO', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', 'TEST SUB LOC', 'RACK TEST', '', 'NOS', 1, 'Y', NULL, '117460 : DILIP KUMAR MISHRA', '116291 : MOHAN PRASAD', NULL, '2024-04-13 00:00:00', '2024-04-13 10:23:56', 'usertool', 20013, 1, 'A'),
(701070, 101057, 5, 'StockSCRAP', 'SCP', 11057, '', 'TEST MATERIAL CRIT', 'Toolkit Store', '', '', '', 'NOS', 2, 'Y', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:24:49', 'usertool', 20014, 1, 'A'),
(701071, 101056, 4, 'StockAdjustment', 'AI', 11056, '', 'TEST MATERIAL', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', NULL, NULL, NULL, 'adjust for MAR-2024 Stock Adjust Process', '2024-04-13 00:00:00', '2024-04-13 10:28:08', 'usertool', 20015, 1, 'A'),
(701072, 101060, 1, 'StockINExcel', 'SI', 11058, '', 'COMPUTER', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-04-11 00:00:00', '2024-04-13 10:34:54', 'usertool', 20016, 1, 'A'),
(701073, 101061, 1, 'StockINExcel', 'SI', 11059, '', 'KEYBOARD', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', '', NULL, NULL, NULL, '2024-04-12 00:00:00', '2024-04-13 10:34:54', 'usertool', 20016, 2, 'A'),
(701074, 101062, 1, 'StockINExcel', 'SI', 11060, '', 'MOUSE', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:34:54', 'usertool', 20016, 3, 'A'),
(701075, 101060, 2, 'StockAdjustmentExcel', 'AI', 11058, '', 'COMPUTER', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:40:28', 'usertool', 20018, 1, 'A'),
(701076, 101062, 2, 'StockAdjustmentExcel', 'AI', 11060, '', 'MOUSE', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:40:28', 'usertool', 20018, 2, 'A'),
(701077, 101063, 1, 'StockAdjustment', 'AI', 11061, '', 'PROCESSOR', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-04-13 10:46:30', '2024-04-13 10:46:30', 'usertool', 20019, 1, 'A'),
(701078, 101063, 2, 'StockIN', 'SI', 11061, '', 'PROCESSOR', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:48:47', 'usertool', 20020, 1, 'A'),
(701079, 101063, 3, 'StockIN', 'SI', 11061, '', 'PROCESSOR', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', NULL, NULL, NULL, NULL, '2024-04-13 00:00:00', '2024-04-13 10:49:47', 'usertool', 20021, 1, 'A'),
(701080, 101063, 4, 'StockOUT', 'SO', 11061, '', 'PROCESSOR', 'Toolkit Store', '', '', '', 'NOS', 8, 'N', NULL, '116291 : MOHAN PRASAD', 'RS10001 : ARUN KUMAR GUPTA', NULL, '2024-04-13 00:00:00', '2024-04-13 10:50:23', 'usertool', 20022, 1, 'A'),
(701081, 101063, 5, 'StockOUT', 'SO', 11061, '', 'PROCESSOR', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', NULL, '116291 : MOHAN PRASAD', 'RS10001 : ARUN KUMAR GUPTA', NULL, '2024-04-13 00:00:00', '2024-04-13 10:51:07', 'usertool', 20023, 1, 'A'),
(701082, 101064, 1, 'StockAdjustment', 'AI', 11062, '9090A1010', 'TEST MATRIAL', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-05-03 15:26:12', '2024-05-03 15:26:12', 'usertool', 20024, 1, 'A'),
(701083, 100002, 4, 'InternalMovement', 'TO', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 5, 'N', NULL, NULL, NULL, NULL, '2024-05-03 00:00:00', '2024-05-03 15:43:10', 'usertool', 20025, 1, 'A'),
(701084, 101065, 1, 'InternalMovement', 'TI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', 'CABLE YARD', 'R1-A', '', 'M', 2, 'N', NULL, NULL, NULL, NULL, '2024-05-03 00:00:00', '2024-05-03 15:43:10', 'usertool', 20025, 1, 'A'),
(701085, 101066, 1, 'InternalMovement', 'TI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', 'OUTSIDE STORE', 'R1-B', '', 'M', 3, 'N', NULL, NULL, NULL, NULL, '2024-05-03 00:00:00', '2024-05-03 15:43:10', 'usertool', 20025, 1, 'A'),
(701086, 101067, 1, 'StockAdjustment', 'AI', 11063, '1212A9090', 'BOILER', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-07-08 16:52:26', '2024-07-08 16:52:26', 'usertool', 20035, 1, 'A'),
(701087, 101067, 2, 'StockIN', 'SI', 11063, '1212A9090', 'BOILER', 'Toolkit Store', '', '', '', 'NOS', 34, 'N', NULL, NULL, NULL, NULL, '2024-10-10 00:00:00', '2024-07-08 16:53:27', 'usertool', 20036, 1, 'A'),
(701088, 100003, 4, 'StockIN', 'SI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 99, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 12:27:54', 'usertool', 20037, 1, 'A'),
(701089, 100017, 2, 'StockOUT', 'SO', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', 'Toolkit Store', '', '', '', 'NOS', 12, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 15:40:38', 'usertool', 20038, 1, 'A'),
(701090, 100017, 3, 'StockOUT', 'SO', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 15:41:22', 'usertool', 20039, 1, 'A'),
(701091, 100011, 2, 'StockOUT', 'SO', 10011, '0093A0119', 'CABLE GLAND  19 MM', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', NULL, '116454 : ARUN KUMAR GUPTA', 'RAKA : KAKA', NULL, '2024-07-13 00:00:00', '2024-07-13 16:15:23', 'usertool', 20040, 1, 'A'),
(701092, 100003, 5, 'StockOUT', 'SO', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', NULL, '146449 : CHOUDHARY BRAHAM NARAYAN RAM', '100200 : Mango', NULL, '2024-07-13 00:00:00', '2024-07-13 16:16:36', 'usertool', 20041, 1, 'A'),
(701093, 100003, 6, 'StockTransfer', 'TO', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', 'Caster', NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 16:27:54', 'usertool', 20042, 1, 'A'),
(701094, 101068, 1, 'StockTransfer', 'TI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Caster', '', '', '', 'NOS', 2, 'N', 'Toolkit Store', NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 16:27:54', 'usertool', 20042, 1, 'A'),
(701095, 100011, 3, 'StockTransfer', 'TO', 10011, '0093A0119', 'CABLE GLAND  19 MM', 'Toolkit Store', '', '', '', 'NOS', 6, 'N', 'SMLP', NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 16:29:38', 'usertool', 20043, 1, 'A'),
(701096, 101069, 1, 'StockTransfer', 'TI', 10011, '0093A0119', 'CABLE GLAND  19 MM', 'SMLP', '', '', '', 'NOS', 6, 'N', 'Toolkit Store', NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 16:29:38', 'usertool', 20043, 1, 'A'),
(701097, 100002, 5, 'InternalMovement', 'TO', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 2, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 18:26:24', 'usertool', 20044, 1, 'A'),
(701098, 101070, 1, 'InternalMovement', 'TI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '9MTR STORE', 'RACK 1', '', 'M', 2, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 18:26:24', 'usertool', 20044, 1, 'A'),
(701099, 100003, 7, 'StockSCRAP', 'SCP', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 18:34:04', 'usertool', 20045, 1, 'A'),
(701100, 100003, 8, 'StockSCRAP', 'SCP', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', 'Toolkit Store', '', '', '', 'NOS', 3, 'N', NULL, NULL, NULL, NULL, '2024-07-13 00:00:00', '2024-07-13 18:34:16', 'usertool', 20046, 1, 'A'),
(701101, 100002, 6, 'StockAdjustment', 'AI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', 'Toolkit Store', '', '', '', 'M', 7, 'N', NULL, NULL, NULL, 'india', '2024-07-13 00:00:00', '2024-07-13 18:39:10', 'usertool', 20047, 1, 'A'),
(701102, 101071, 1, 'StockIN', 'SI', 11064, '', 'ABCINDIA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '2', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 07:40:55', 'usertool', 20053, 1, 'A'),
(701103, 101072, 1, 'StockIN', 'SI', 11065, '', 'CIBGI', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', '5', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 07:40:55', 'usertool', 20053, 2, 'A'),
(701104, 101073, 1, 'StockIN', 'SI', 11066, '', 'ABCINDIA', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 07:46:52', 'usertool', 20054, 1, 'A'),
(701105, 101074, 1, 'StockIN', 'SI', 11067, '', 'CIBGI', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 07:46:52', 'usertool', 20054, 2, 'A'),
(701106, 101075, 1, 'StockIN', 'SI', 11068, '', 'ABCINDIA', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 09:51:39', 'usertool', 20055, 1, 'A'),
(701107, 101076, 1, 'StockIN', 'SI', 11069, '', 'CIBGI', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 09:51:39', 'usertool', 20055, 2, 'A'),
(701108, 101075, 2, 'StockIN', 'SI', 11068, '', 'ABCINDIA', 'Toolkit Store', '', '', '', 'NOS', 2, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:09:16', 'usertool', 20056, 1, 'A'),
(701109, 101076, 2, 'StockIN', 'SI', 11069, '', 'CIBGI', 'Toolkit Store', '', '', '', 'NOS', 5, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:09:16', 'usertool', 20056, 2, 'A'),
(701110, 101077, 1, 'StockIN', 'SI', 11070, '', 'WHAT A JOKE', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:10:58', 'usertool', 20057, 1, 'A'),
(701111, 101078, 1, 'StockIN', 'SI', 11071, '', 'HE HE HE HE', 'Toolkit Store', '', '', '', 'NOS', 15, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:10:58', 'usertool', 20057, 2, 'A'),
(701112, 101077, 2, 'StockAdjustment', 'AI', 11070, '', 'WHAT A JOKE', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:11:28', 'usertool', 20058, 1, 'A'),
(701113, 101078, 2, 'StockAdjustment', 'AI', 11071, '', 'HE HE HE HE', 'Toolkit Store', '', '', '', 'NOS', 15, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:11:28', 'usertool', 20058, 2, 'A'),
(701114, 101077, 3, 'StockIN', 'SI', 11070, '', 'WHAT A JOKE', 'Toolkit Store', '', '', '', 'NOS', 10, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:12:19', 'usertool', 20059, 1, 'A'),
(701115, 101078, 3, 'StockIN', 'SI', 11071, '', 'HE HE HE HE', 'Toolkit Store', '', '', '', 'NOS', 15, 'N', '', NULL, NULL, NULL, '2024-07-14 00:00:00', '2024-07-14 10:12:19', 'usertool', 20059, 2, 'A'),
(701116, 101079, 1, 'StockAdjustment', 'AI', 11072, '1001E9090', 'ABCINDIA', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-07-16 14:28:14', '2024-07-16 14:28:14', 'usertool', 20060, 1, 'A'),
(701117, 101080, 1, 'StockAdjustment', 'AI', 11073, '2020R2001', 'BONGO', 'Toolkit Store', '', '', '', 'NOS', 0, 'N', NULL, NULL, NULL, NULL, '2024-07-16 14:29:18', '2024-07-16 14:29:18', 'usertool', 20061, 1, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_block`
--

CREATE TABLE `t_stock_block` (
  `id` int(11) NOT NULL,
  `block` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_company`
--

CREATE TABLE `t_stock_company` (
  `id` int(11) NOT NULL,
  `cmpcd` varchar(10) DEFAULT NULL,
  `company` varchar(50) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_company`
--

INSERT INTO `t_stock_company` (`id`, `cmpcd`, `company`, `sts`, `cbid`, `cby`, `cdt`) VALUES
(1, '1000', 'TATA STEEL JSR', 'DELETED', 1, 'ADMIN', '2024-07-21 22:30:26'),
(2, '1000', 'TATA STEEL JSR', 'ACTIVE', 1, 'ADMIN', '2024-07-21 22:45:30'),
(3, '1000', 'TATA STEEL JSR', 'ACTIVE', 1, 'ADMIN', '2024-07-21 22:51:33'),
(4, '1000', 'TATA STEEL JSR', 'ACTIVE', 1, 'ADMIN', '2024-07-21 23:16:34');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_department`
--

CREATE TABLE `t_stock_department` (
  `id` int(11) NOT NULL,
  `deptcd` varchar(10) DEFAULT NULL,
  `dept` varchar(50) DEFAULT NULL,
  `cmpid` int(11) DEFAULT NULL,
  `cmpcd` varchar(10) DEFAULT NULL,
  `plntid` int(11) DEFAULT NULL,
  `plntcd` varchar(10) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_department`
--

INSERT INTO `t_stock_department` (`id`, `deptcd`, `dept`, `cmpid`, `cmpcd`, `plntid`, `plntcd`, `sts`, `cbid`, `cby`, `cdt`) VALUES
(1, '101', 'LD1', 1, '1000', 1, 'PL1000', 'ACTIVE', 1, 'ADMIN', '2024-07-22 06:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_excel`
--

CREATE TABLE `t_stock_excel` (
  `id` int(11) NOT NULL,
  `process` varchar(30) DEFAULT NULL,
  `dt` datetime DEFAULT NULL,
  `lcid` int(11) DEFAULT NULL,
  `loc` varchar(50) DEFAULT NULL,
  `rem` varchar(200) DEFAULT NULL,
  `sts` varchar(30) DEFAULT NULL,
  `cby` varchar(30) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_excel`
--

INSERT INTO `t_stock_excel` (`id`, `process`, `dt`, `lcid`, `loc`, `rem`, `sts`, `cby`, `cdt`) VALUES
(50001, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'Released', 'usertool', '2024-07-14 10:10:54'),
(50002, 'StockAdjustment', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'Released', 'usertool', '2024-07-14 10:11:22'),
(50003, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'Released', 'usertool', '2024-07-14 10:12:16'),
(50004, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:14:23'),
(50005, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:14:30'),
(50006, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:14:52'),
(50007, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:15:05'),
(50008, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:17:06'),
(50009, 'StockIN', '2024-07-14 00:00:00', 1, 'Toolkit Store', '', 'New', 'usertool', '2024-07-14 10:17:14');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_excel_line`
--

CREATE TABLE `t_stock_excel_line` (
  `id` int(11) NOT NULL,
  `seid` int(11) NOT NULL,
  `sl` int(11) NOT NULL,
  `dt` varchar(15) DEFAULT NULL,
  `itid` int(11) DEFAULT NULL,
  `mtcd` varchar(20) DEFAULT NULL,
  `material` varchar(150) DEFAULT NULL,
  `make` varchar(40) NOT NULL,
  `uom` varchar(30) DEFAULT NULL,
  `critical` varchar(1) DEFAULT NULL,
  `loc` varchar(40) NOT NULL,
  `sloc` varchar(40) DEFAULT NULL,
  `ssloc` varchar(40) DEFAULT NULL,
  `toloc` varchar(50) DEFAULT NULL,
  `tosloc` varchar(40) DEFAULT NULL,
  `tossloc` varchar(40) DEFAULT NULL,
  `qty` int(10) UNSIGNED DEFAULT NULL,
  `skid` varchar(10) DEFAULT NULL,
  `rem` varchar(200) DEFAULT NULL,
  `scsts` varchar(1) DEFAULT NULL,
  `wlvl` int(10) UNSIGNED DEFAULT '0',
  `rlvl` int(10) UNSIGNED DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_excel_line`
--

INSERT INTO `t_stock_excel_line` (`id`, `seid`, `sl`, `dt`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `toloc`, `tosloc`, `tossloc`, `qty`, `skid`, `rem`, `scsts`, `wlvl`, `rlvl`) VALUES
(10001, 50001, 1, '14.07.2024', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', 'UMC Created : (11070) : StockIN : Done with Quantity ( 10 )', 'Y', 0, 0),
(10002, 50001, 2, '14.07.2024', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', 'UMC Created : (11071) : StockIN : Done with Quantity ( 15 )', 'Y', 0, 0),
(10003, 50002, 1, '14.07.2024', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', 'StockAdjustment : Done with Quantity ( 10 )', 'Y', 0, 0),
(10004, 50002, 2, '14.07.2024', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', 'StockAdjustment : Done with Quantity ( 15 )', 'Y', 0, 0),
(10005, 50003, 1, '14.07.2024', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', 'StockIN : Done with Quantity ( 10 )', 'Y', 0, 0),
(10006, 50003, 2, '14.07.2024', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', 'StockIN : Done with Quantity ( 15 )', 'Y', 0, 0),
(10007, 50004, 1, '14.07.2024', NULL, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', NULL, 'N', 0, 0),
(10008, 50004, 2, '14.07.2024', NULL, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', NULL, 'N', 0, 0),
(10009, 50005, 1, '14.07.2024', NULL, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', NULL, 'N', 0, 0),
(10010, 50005, 2, '14.07.2024', NULL, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', NULL, 'N', 0, 0),
(10011, 50006, 1, '14.07.2024', NULL, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', NULL, 'N', 0, 0),
(10012, 50006, 2, '14.07.2024', NULL, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', NULL, 'N', 0, 0),
(10013, 50007, 1, '14.07.2024', NULL, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', NULL, 'N', 0, 0),
(10014, 50007, 2, '14.07.2024', NULL, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', NULL, 'N', 0, 0),
(10015, 50008, 1, '14.07.2024', NULL, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 10, '', NULL, 'N', 0, 0),
(10016, 50008, 2, '14.07.2024', NULL, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', '', '', '', 15, '', NULL, 'N', 0, 0),
(10017, 50009, 1, 'Y', NULL, '', '14.07.2024', '', 'WHAT A JOKE', 'N', 'Toolkit Store', '', 'NOS', '', '', '', 0, '1', NULL, 'N', 0, 10),
(10018, 50009, 2, 'Y', NULL, '', '14.07.2024', '', 'HE HE HE HE', 'N', 'Toolkit Store', '', 'NOS', '', '', '', 0, '2', NULL, 'N', 0, 15);

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_location`
--

CREATE TABLE `t_stock_location` (
  `id` int(11) NOT NULL,
  `loc` varchar(30) DEFAULT NULL,
  `cmpid` int(11) DEFAULT NULL,
  `cmpcd` varchar(10) DEFAULT NULL,
  `plntid` int(11) DEFAULT NULL,
  `plntcd` varchar(10) DEFAULT NULL,
  `deptid` int(11) DEFAULT NULL,
  `deptcd` varchar(10) DEFAULT NULL,
  `dept` varchar(50) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_location`
--

INSERT INTO `t_stock_location` (`id`, `loc`, `cmpid`, `cmpcd`, `plntid`, `plntcd`, `deptid`, `deptcd`, `dept`, `sts`, `cbid`, `cby`, `cdt`) VALUES
(1, 'Tool Room', 1, '1000', 1, 'PL1000', 1, '101', 'LD1', 'ACTIVE', 1, 'ADMIN', '2024-07-27 17:40:00');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material`
--

CREATE TABLE `t_stock_material` (
  `id` int(11) NOT NULL,
  `mtcd` varchar(20) DEFAULT '',
  `omtcd` varchar(20) DEFAULT '',
  `material` varchar(150) DEFAULT '',
  `descp` varchar(200) DEFAULT '',
  `ittp` varchar(30) DEFAULT '',
  `rating` varchar(30) DEFAULT '',
  `uom` varchar(30) DEFAULT '',
  `appl` varchar(40) DEFAULT '',
  `wrlvl` int(11) DEFAULT '0',
  `rolvl` int(11) DEFAULT '0',
  `critical` varchar(5) DEFAULT 'No',
  `dfrate` int(11) DEFAULT NULL,
  `dfmake` varchar(50) DEFAULT NULL,
  `age` smallint(6) DEFAULT NULL,
  `enblmultmake` varchar(5) DEFAULT NULL,
  `enblsubloc` varchar(5) DEFAULT NULL,
  `enblmultrate` varchar(5) DEFAULT NULL,
  `abctp` varchar(20) DEFAULT NULL,
  `ecdtp` varchar(20) DEFAULT NULL,
  `cmpid` int(11) DEFAULT NULL,
  `cmpcd` varchar(10) DEFAULT NULL,
  `plntid` int(11) DEFAULT NULL,
  `plntcd` varchar(10) DEFAULT NULL,
  `deptid` int(11) DEFAULT NULL,
  `deptcd` varchar(10) DEFAULT NULL,
  `dept` varchar(50) DEFAULT NULL,
  `lcid` int(11) DEFAULT NULL,
  `loc` varchar(50) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL,
  `avl` int(10) UNSIGNED DEFAULT '0',
  `sti` int(10) UNSIGNED DEFAULT '0',
  `sto` int(10) UNSIGNED DEFAULT '0',
  `tri` int(10) UNSIGNED DEFAULT '0',
  `tro` int(10) UNSIGNED DEFAULT '0',
  `adi` int(10) UNSIGNED DEFAULT '0',
  `ado` int(10) UNSIGNED DEFAULT '0',
  `scp` int(10) UNSIGNED DEFAULT '0',
  `rsv` int(10) UNSIGNED DEFAULT '0',
  `isr` int(10) UNSIGNED DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material_application`
--

CREATE TABLE `t_stock_material_application` (
  `id` int(11) NOT NULL,
  `appl` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material_make`
--

CREATE TABLE `t_stock_material_make` (
  `id` int(11) NOT NULL,
  `make` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material_rating`
--

CREATE TABLE `t_stock_material_rating` (
  `id` int(11) NOT NULL,
  `rating` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material_type`
--

CREATE TABLE `t_stock_material_type` (
  `id` int(11) NOT NULL,
  `mttp` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_material_uom`
--

CREATE TABLE `t_stock_material_uom` (
  `id` int(11) NOT NULL,
  `uom` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_out_emp`
--

CREATE TABLE `t_stock_out_emp` (
  `id` int(11) NOT NULL,
  `pno` varchar(10) DEFAULT NULL,
  `enm` varchar(50) DEFAULT NULL,
  `lcid` int(11) DEFAULT NULL,
  `loc` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_out_emp`
--

INSERT INTO `t_stock_out_emp` (`id`, `pno`, `enm`, `lcid`, `loc`) VALUES
(1, '116291', 'MOHAN PRASAD', 1, 'Toolkit Store'),
(2, '116454', 'ARUN KUMAR GUPTA', 1, 'Toolkit Store'),
(3, '117460', 'DILIP KUMAR MISHRA', 1, 'Toolkit Store'),
(4, '119102', 'BENJAMIN TOPNO', 1, 'Toolkit Store'),
(5, '121328', 'BIDDYUT DATTA', 1, 'Toolkit Store'),
(6, '121332', 'PANNA LAL MONDAL', 1, 'Toolkit Store'),
(7, '121363', 'PARTHA PRATIM GHOSH', 1, 'Toolkit Store'),
(8, '121428', 'BIJAN KUMAR ROY', 1, 'Toolkit Store'),
(9, '121429', 'RADHA RAMAN DAS', 1, 'Toolkit Store'),
(10, '122392', 'RAJ KUMAR PRASAD', 1, 'Toolkit Store'),
(11, '122785', 'NARENDRA KR PATEL', 1, 'Toolkit Store'),
(12, '124521', 'DEBASIS DUTTA', 1, 'Toolkit Store'),
(13, '124522', 'PARTHA PRATIM DHAR', 1, 'Toolkit Store'),
(14, '124560', 'KANHAIYA DUBEY', 1, 'Toolkit Store'),
(15, '126380', 'MANOWAR ALI', 1, 'Toolkit Store'),
(16, '126520', 'SUMAN KR CHOUDHARY', 1, 'Toolkit Store'),
(17, '146346', 'BIMAL PRASAD MOHARATHA', 1, 'Toolkit Store'),
(18, '146420', 'ANIL KUMAR', 1, 'Toolkit Store'),
(19, '146449', 'CHOUDHARY BRAHAM NARAYAN RAM', 1, 'Toolkit Store'),
(20, '148926', 'MD. PASHA KHAN', 1, 'Toolkit Store'),
(21, '154809', 'RAMESH MURMU', 1, 'Toolkit Store'),
(22, '154821', 'SUROJIT DAS', 1, 'Toolkit Store'),
(23, '154823', 'ASHOK KUMAR', 1, 'Toolkit Store'),
(24, '154850', 'AJAY KUMAR SINGH', 1, 'Toolkit Store'),
(25, '154989', 'SANJAY KUMAR LAL', 1, 'Toolkit Store'),
(27, '195799', 'AJAYA KUMAR SAHOO', 1, 'Toolkit Store'),
(28, '195987', 'KHITISH CH MOHANTY', 1, 'Toolkit Store'),
(29, '196162', 'PRAKASHA HANSADA', 1, 'Toolkit Store'),
(30, '500089', 'SANKAR PRASAD NEOGI', 1, 'Toolkit Store'),
(31, '500133', 'AMRIT SINGH', 1, 'Toolkit Store'),
(32, '500148', 'APPU KUMAR', 1, 'Toolkit Store'),
(33, '500362', 'MUKESH KUMAR SINGH', 1, 'Toolkit Store'),
(34, '502937', 'RAJESH KUMAR', 1, 'Toolkit Store'),
(35, '504078', 'GIRISH KUMAR PRASAD', 1, 'Toolkit Store'),
(36, '504497', 'SUMIT DAS', 1, 'Toolkit Store'),
(37, '504533', 'ANIL KUMAR SINGH', 1, 'Toolkit Store'),
(38, '504541', 'RAJANI KUMARI', 1, 'Toolkit Store'),
(39, '505491', 'J DOLLY', 1, 'Toolkit Store'),
(40, '505929', 'NITISH KUMAR', 1, 'Toolkit Store'),
(41, '505931', 'ANKIT KUMAR', 1, 'Toolkit Store'),
(42, '505932', 'SUKHLAL BODRA', 1, 'Toolkit Store'),
(43, '505933', 'RUPA KUMARI SINGH', 1, 'Toolkit Store'),
(44, '505934', 'PREET KUMAR PATHAK', 1, 'Toolkit Store'),
(45, '506046', 'URVASHI KUMARI', 1, 'Toolkit Store'),
(46, '506307', 'SHANI KUMAR', 1, 'Toolkit Store'),
(47, '506803', 'ROHIT KUMAR SINGH', 1, 'Toolkit Store'),
(48, '506811', 'AKASH JHA', 1, 'Toolkit Store'),
(49, '506982', 'PRABHAT RANJAN SINHA', 1, 'Toolkit Store'),
(50, '506992', 'MRIDULA TIWARY', 1, 'Toolkit Store'),
(51, '506994', 'PRITY SRIVASTAVA', 1, 'Toolkit Store'),
(52, '507083', 'JAYA DUTTA', 1, 'Toolkit Store'),
(53, '507152', 'ABHILASH GORAI', 1, 'Toolkit Store'),
(54, '507165', 'GAURAV KUMAR', 1, 'Toolkit Store'),
(55, '507387', 'AKASH CHAKRABORTY', 1, 'Toolkit Store'),
(56, '507390', 'ARMAN ALI', 1, 'Toolkit Store'),
(57, '507404', 'VISHAL KUMAR', 1, 'Toolkit Store'),
(58, '507681', 'KUMARI NIDHI', 1, 'Toolkit Store'),
(59, '831346', 'BITTU KUMAR', 1, 'Toolkit Store'),
(60, '831600', 'ANURAG KUMAR', 1, 'Toolkit Store'),
(61, '831639', 'DAMU PAREYA', 1, 'Toolkit Store'),
(62, '831660', 'RAHUL KUMAR', 1, 'Toolkit Store'),
(63, '831752', 'HIMANSHU PRASAD', 1, 'Toolkit Store'),
(64, '832404', 'ASHISH KUMAR', 1, 'Toolkit Store'),
(65, '832409', 'KHUSWANT KR DESHMUKH', 1, 'Toolkit Store'),
(66, '832425', 'NAWAZISH ANSARI', 1, 'Toolkit Store'),
(67, '832437', 'KUNDAN LAL SAHU', 1, 'Toolkit Store'),
(68, '832519', 'HUMENDRA KUMAR', 1, 'Toolkit Store'),
(69, '832521', 'PRANAY MANDAL', 1, 'Toolkit Store'),
(70, '509686', 'DEEPAK ORAON ', 1, 'Toolkit Store'),
(71, '510170', 'MANISH KUMAR', 1, 'Toolkit Store'),
(72, '510214', 'MANISH TIRKEY', 1, 'Toolkit Store'),
(73, '510215', 'JIYAUL RAHMAN', 1, 'Toolkit Store'),
(74, '510216', 'VIVEK RAJ SINGH', 1, 'Toolkit Store'),
(75, '832057', 'RAHUL KUMAR', 1, 'Toolkit Store'),
(76, '510020', 'Jay Kumar Shahi', 1, 'Toolkit Store'),
(77, '510008', 'Akashdeep Mahato', 1, 'Toolkit Store'),
(78, '510049', 'Saurav Kumar', 1, 'Toolkit Store'),
(79, '511295', 'PERMESHWAR MARDI', 1, 'Toolkit Store'),
(80, '511296', 'RANJEET MAHATO', 1, 'Toolkit Store'),
(81, '832217', 'RADHIKA PRIYA', 1, 'Toolkit Store'),
(82, '832203', 'VIKASH', 1, 'Toolkit Store'),
(83, '116290', 'A. Kumar', 1, 'Toolkit Store'),
(84, '121338', 'Goutam Das', 1, 'Toolkit Store'),
(85, '123222', 'Mukesh Kumar', 1, 'Toolkit Store'),
(86, '149274', 'Tribhuwan Narayan Singh', 1, 'Toolkit Store'),
(87, '153592', 'Sushil Roy', 1, 'Toolkit Store'),
(88, '163702', 'Soumyojit Datta', 1, 'Toolkit Store'),
(89, '500509', 'Pankaj Kumar Upadhyay', 1, 'Toolkit Store'),
(90, '504894', 'Amarendra Dash', 1, 'Toolkit Store'),
(91, '805190', 'Gaurav Kumar', 1, 'Toolkit Store'),
(92, '162194', 'Channa Seethal', 1, 'Toolkit Store'),
(93, '198216', 'Rahul Kumar Singh', 1, 'Toolkit Store'),
(94, '153528', 'Samarjeet Mohanty', 1, 'Toolkit Store'),
(95, '832404', 'ASHISH', 2, 'Vessel');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_out_emp_issue`
--

CREATE TABLE `t_stock_out_emp_issue` (
  `id` int(11) NOT NULL,
  `spno` varchar(20) DEFAULT NULL,
  `ctnm` varchar(30) DEFAULT NULL,
  `lcid` int(11) DEFAULT NULL,
  `loc` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_out_emp_issue`
--

INSERT INTO `t_stock_out_emp_issue` (`id`, `spno`, `ctnm`, `lcid`, `loc`) VALUES
(1, '100200', 'Mango', 1, 'Toolkit Store');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_plant`
--

CREATE TABLE `t_stock_plant` (
  `id` int(11) NOT NULL,
  `plntcd` varchar(10) DEFAULT NULL,
  `plant` varchar(50) DEFAULT NULL,
  `cmpid` int(11) DEFAULT NULL,
  `cmpcd` varchar(10) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_plant`
--

INSERT INTO `t_stock_plant` (`id`, `plntcd`, `plant`, `cmpid`, `cmpcd`, `sts`, `cbid`, `cby`, `cdt`) VALUES
(1, 'PL1000', 'CRM', 1, '1000', 'ACTIVE', 1, 'ADMIN', '2024-07-21 23:21:18'),
(2, 'PL1000', 'CRM', 1, '1000', 'ACTIVE', 1, 'ADMIN', '2024-07-21 23:21:48'),
(3, 'PL1000', 'CRM', 1, '1000', 'ACTIVE', 1, 'ADMIN', '2024-07-21 23:22:14'),
(4, 'PL1000', 'CRM', 1, '1000', 'ACTIVE', 1, 'ADMIN', '2024-07-21 23:23:12');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_process`
--

CREATE TABLE `t_stock_process` (
  `id` int(10) UNSIGNED NOT NULL,
  `process` varchar(45) DEFAULT NULL,
  `dt` datetime NOT NULL,
  `descp` varchar(200) DEFAULT NULL,
  `ispno` varchar(10) DEFAULT NULL,
  `isto` varchar(45) DEFAULT NULL,
  `tknspno` varchar(45) DEFAULT NULL,
  `tknby` varchar(45) DEFAULT NULL,
  `sts` varchar(30) DEFAULT NULL,
  `loc` varchar(40) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL,
  `cby` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_process`
--

INSERT INTO `t_stock_process` (`id`, `process`, `dt`, `descp`, `ispno`, `isto`, `tknspno`, `tknby`, `sts`, `loc`, `cdt`, `cby`) VALUES
(20001, 'StockAdjustmentExcel', '2024-02-29 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-03-21 14:55:28', 'usertool'),
(20002, 'StockIN', '2024-03-28 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-03-28 12:09:36', 'usertool'),
(20003, 'StockIN', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:01:14', 'usertool'),
(20004, 'StockOUT', '2024-04-13 00:00:00', '', '116454', 'ARUN KUMAR GUPTA', 'RS10001', 'ARUN KUMAR GUPTA', 'Released', 'Toolkit Store', '2024-04-13 10:02:20', 'usertool'),
(20005, 'StockOUT', '2024-04-13 00:00:00', '', '116454', 'ARUN KUMAR GUPTA', 'RS10001', 'ARUN KUMAR GUPTA', 'Released', 'Toolkit Store', '2024-04-13 10:03:07', 'usertool'),
(20006, 'StockAdjustment', '2024-04-13 10:05:41', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:05:41', 'usertool'),
(20007, 'StockAdjustment', '2024-04-13 10:06:29', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:06:29', 'usertool'),
(20008, 'StockIN', '2024-04-11 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:12:39', 'usertool'),
(20009, 'StockIN', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:13:58', 'usertool'),
(20010, 'StockOUT', '2024-04-12 00:00:00', '', '116291', 'MOHAN PRASAD', '116291', 'MOHAN PRASAD', 'Released', 'Toolkit Store', '2024-04-13 10:15:48', 'usertool'),
(20011, 'StockTransfer', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-04-13 10:17:37', 'usertool'),
(20012, 'InternalMovement', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:21:16', 'usertool'),
(20013, 'StockOUT', '2024-04-13 00:00:00', '', '117460', 'DILIP KUMAR MISHRA', '116291', 'MOHAN PRASAD', 'Released', 'Toolkit Store', '2024-04-13 10:23:56', 'usertool'),
(20014, 'StockSCRAP', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:24:49', 'usertool'),
(20015, 'StockAdjustment', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:28:08', 'usertool'),
(20016, 'StockINExcel', '2024-04-13 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:34:54', 'usertool'),
(20017, 'StockTransferExcel', '2024-04-13 00:00:00', NULL, NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-04-13 10:38:33', 'usertool'),
(20018, 'StockAdjustmentExcel', '2024-04-13 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:40:28', 'usertool'),
(20019, 'StockAdjustment', '2024-04-13 10:46:30', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:46:30', 'usertool'),
(20020, 'StockIN', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:48:47', 'usertool'),
(20021, 'StockIN', '2024-04-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-04-13 10:49:46', 'usertool'),
(20022, 'StockOUT', '2024-04-13 00:00:00', '', '116291', 'MOHAN PRASAD', 'RS10001', 'ARUN KUMAR GUPTA', 'Released', 'Toolkit Store', '2024-04-13 10:50:23', 'usertool'),
(20023, 'StockOUT', '2024-04-13 00:00:00', '', '116291', 'MOHAN PRASAD', 'RS10001', 'ARUN KUMAR GUPTA', 'Released', 'Toolkit Store', '2024-04-13 10:51:07', 'usertool'),
(20024, 'StockAdjustment', '2024-05-03 15:26:12', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-05-03 15:26:12', 'usertool'),
(20025, 'InternalMovement', '2024-05-03 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-05-03 15:43:10', 'usertool'),
(20026, 'StockIN', '2024-10-10 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'JSR', '2024-07-03 23:22:18', '100'),
(20027, 'StockIN', '2024-10-10 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'JSR', '2024-07-03 23:34:54', '100'),
(20028, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'JSR', '2024-07-08 15:23:53', '100'),
(20029, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'JSR', '2024-07-08 15:51:07', '100'),
(20030, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'JSR', '2024-07-08 15:54:10', '100'),
(20031, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-07-08 16:27:48', 'usertool'),
(20032, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-07-08 16:29:10', 'usertool'),
(20033, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-07-08 16:29:42', 'usertool'),
(20034, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'New', 'Toolkit Store', '2024-07-08 16:29:49', 'usertool'),
(20035, 'StockAdjustment', '2024-07-08 16:52:26', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-08 16:52:26', 'usertool'),
(20036, 'StockIN', '2024-07-08 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-08 16:53:08', 'usertool'),
(20037, 'StockIN', '2024-07-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-13 12:27:54', 'usertool'),
(20038, 'StockIN', '2024-07-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-13 15:40:38', 'usertool'),
(20039, 'StockIN', '2024-07-13 00:00:00', '', NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-13 15:41:22', 'usertool'),
(20040, 'StockIN', '2024-07-13 00:00:00', '', '116454', 'ARUN KUMAR GUPTA', 'RAKA', 'KAKA', 'Released', 'Toolkit Store', '2024-07-13 16:15:23', 'usertool'),
(20041, 'StockIN', '2024-07-13 00:00:00', '', '146449', 'CHOUDHARY BRAHAM NARAYAN RAM', '100200', 'Mango', 'Released', 'Toolkit Store', '2024-07-13 16:16:36', 'usertool'),
(20042, 'StockIN', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 16:27:54', 'usertool'),
(20043, 'StockTransfer', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 16:29:38', 'usertool'),
(20044, 'InternalMovement', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 18:26:24', 'usertool'),
(20045, 'StockSCRAP', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 18:34:04', 'usertool'),
(20046, 'StockSCRAP', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 18:34:16', 'usertool'),
(20047, 'StockAdjustment', '2024-07-13 00:00:00', '', '', '', '', '', 'Released', 'Toolkit Store', '2024-07-13 18:39:10', 'usertool'),
(20048, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 06:56:46', 'usertool'),
(20049, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:24:40', 'usertool'),
(20050, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:26:28', 'usertool'),
(20051, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:31:26', 'usertool'),
(20052, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:36:15', 'usertool'),
(20053, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:40:54', 'usertool'),
(20054, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 07:46:52', 'usertool'),
(20055, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 09:51:39', 'usertool'),
(20056, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 10:09:16', 'usertool'),
(20057, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 10:10:58', 'usertool'),
(20058, 'StockAdjustment', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 10:11:28', 'usertool'),
(20059, 'StockIN', '2024-07-14 00:00:00', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-14 10:12:19', 'usertool'),
(20060, 'StockAdjustment', '2024-07-16 14:28:14', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-16 14:28:14', 'usertool'),
(20061, 'StockAdjustment', '2024-07-16 14:29:18', NULL, NULL, NULL, NULL, NULL, 'Released', 'Toolkit Store', '2024-07-16 14:29:18', 'usertool');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_process_code`
--

CREATE TABLE `t_stock_process_code` (
  `id` int(11) NOT NULL,
  `process` varchar(30) DEFAULT NULL,
  `code` varchar(4) DEFAULT NULL,
  `tp` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_process_code`
--

INSERT INTO `t_stock_process_code` (`id`, `process`, `code`, `tp`) VALUES
(1, 'StockIN', 'SI', 'Screen'),
(2, 'StockOUT', 'SO', 'Screen'),
(3, 'StockAdjustmentIN', 'AI', 'Internal'),
(4, 'StockAdjustmentOUT', 'AO', 'Internal'),
(5, 'StockAdjustment', 'SA', 'Screen'),
(6, 'StockTransferIN', 'TI', 'Internal'),
(7, 'StockTransferOUT', 'TO', 'Internal'),
(8, 'StockTransfer', 'ST', 'Screen'),
(9, 'StockSCRAP', 'SCP', 'Screen'),
(10, 'InternalMovement', 'IM', 'Screen'),
(11, 'StockReserve', 'RSV', 'Screen'),
(12, 'StockINExcel', 'SIE', 'Excel'),
(13, 'StockAdjustmentExcel', 'SAE', 'Excel'),
(14, 'InternalMovementExcel', 'IME', 'Excel'),
(15, 'StockSCRAPExcel', 'SCPE', 'Excel'),
(16, 'StockTransferExcel', 'STE', 'Excel'),
(17, 'InternalMovementSingle', 'IMS', 'Screen');

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_process_line`
--

CREATE TABLE `t_stock_process_line` (
  `spid` int(11) NOT NULL,
  `sl` int(10) NOT NULL,
  `dt` datetime NOT NULL,
  `bprocess` varchar(30) DEFAULT NULL,
  `process` varchar(5) DEFAULT NULL,
  `itid` int(11) NOT NULL,
  `mtcd` varchar(20) DEFAULT NULL,
  `material` varchar(150) DEFAULT NULL,
  `make` varchar(40) DEFAULT NULL,
  `uom` varchar(30) DEFAULT NULL,
  `critical` varchar(5) DEFAULT NULL,
  `loc` varchar(40) NOT NULL,
  `sloc` varchar(40) DEFAULT NULL,
  `ssloc` varchar(40) DEFAULT NULL,
  `pqty` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `nqty` int(11) DEFAULT NULL,
  `act` int(11) DEFAULT NULL,
  `toloc` varchar(40) DEFAULT NULL,
  `tosloc` varchar(500) DEFAULT NULL,
  `sts` varchar(40) DEFAULT NULL,
  `skid` double DEFAULT NULL,
  `rem` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_process_line`
--

INSERT INTO `t_stock_process_line` (`spid`, `sl`, `dt`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `pqty`, `qty`, `nqty`, `act`, `toloc`, `tosloc`, `sts`, `skid`, `rem`) VALUES
(100, 1, '2024-10-10 00:00:00', 'StockIN', 'SI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'JSR', '', '', NULL, 33, NULL, NULL, NULL, NULL, 'New', 100002, NULL),
(100, 2, '2024-10-10 00:00:00', 'StockIN', 'SI', 0, '', '', '', '', '', 'JSR', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'New', 0, NULL),
(20001, 1, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10001, '', '3 PAIR X0.5 CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100001, NULL),
(20001, 2, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100002, NULL),
(20001, 3, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100003, NULL),
(20001, 4, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10004, '0025C0092', 'BRG ROLLER SINGLE ROW CYL MET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100004, NULL),
(20001, 5, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10005, '0030A0051', 'BRG.ROLLER,DOUBLE ROW,  23136,CCW33', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100005, NULL),
(20001, 6, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10006, '0030B0068', 'BRG.ROLLER,DOUBLE ROW,SP 22226 CCW33', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100006, NULL),
(20001, 7, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10007, '0031A0160', 'BRG. 32312 TAPER ROLLER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100007, NULL),
(20001, 8, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10008, '0031B0007', 'BRG.ROLLERTAPER,SINGLEROW,METRIC(31309,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100008, NULL),
(20001, 9, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10009, '0083A0023', 'TYRE TYPE COUPING & SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100009, NULL),
(20001, 10, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10010, '0088A0095', 'THREADED CABLE GLAND SIZE M20X1.5', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100010, NULL),
(20001, 11, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10011, '0093A0119', 'CABLE GLAND  19 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 266, NULL, NULL, '', '', 'Released', 100011, NULL),
(20001, 12, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10012, '0093A0120', 'CABLE GLAND  22MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100012, NULL),
(20001, 13, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10013, '0096A0138', 'NUTM16', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100013, NULL),
(20001, 14, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10014, '0101D0096', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 35MM\"', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100014, NULL),
(20001, 15, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10015, '0101D0097', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 40MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100015, NULL),
(20001, 16, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10016, '0101D0099', '\"HEX HEAD, HIGH TENSILE BOLT, 8MM, 50MM\"', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100016, NULL),
(20001, 17, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 29, NULL, NULL, '', '', 'Released', 100017, NULL),
(20001, 18, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10018, '0122B0064', 'SAFETY ITEMS ( BARICADE  TAPE)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 142, NULL, NULL, '', '', 'Released', 100018, NULL),
(20001, 19, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10019, '0124A0003', 'HANDGLAVES (LEATHER CUM CANVAS)', '', 'PAA', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100019, NULL),
(20001, 20, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10020, '0150A0025', 'BREATHING APPARATUS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100020, NULL),
(20001, 21, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10021, '0162A0003', 'BULLDOG GRIP 13 MM WIRE ROPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100021, NULL),
(20001, 22, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10022, '0162A0004', 'BULLDOG GRIP 16MM WIRE ROPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100022, NULL),
(20001, 23, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10023, '0162A0007', 'BULLDOG GRIP  25mm', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100023, NULL),
(20001, 24, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10024, '0177A0733', 'Ferrule for 6mm OD x 1mm thick', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100024, NULL),
(20001, 25, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10025, '0207A0048', 'GENERAL TOOLS   -plie', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 25, NULL, NULL, '', '', 'Released', 100025, NULL),
(20001, 26, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10026, '0217A0039', 'MOT.LEAD,1KV,CU,16X1C,HRE ELSTMR INSL', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100026, NULL),
(20001, 27, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10027, '0217A0042', 'FLEX.CABLE,1KV,CU,70X1C,HRE INSULN.', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100027, NULL),
(20001, 28, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10028, '0217A0044', 'FLEX CABLE,1KV,CU,120 X1C ,HRE,INSULN', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100028, NULL),
(20001, 29, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10029, '0217A0045', 'FLEX CABLE,1 KV,CU,150X1C,HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100029, NULL),
(20001, 30, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10030, '0217A0046', 'FLEX CABLE 1 KV CU 240*1C HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100030, NULL),
(20001, 31, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10031, '0217A0049', 'FLEX LEAD,1 KV,CU,2.5X1C,HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100031, NULL),
(20001, 32, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10032, '0237A0081', 'GL.PRPS,FLEX,1KV,CU,2.5X4C,RUBR,RUBR SH', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100032, NULL),
(20001, 33, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10033, '0237A0082', 'GL PRPS FLEX,1KV,CU,6X4C,RUBR,RUBR SH', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100033, NULL),
(20001, 34, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10034, '0237A0087', 'MAGNET CABLE 35SQMM X 2C CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100034, NULL),
(20001, 35, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10035, '0237A0090', 'CABLE FOR LIGHTING PURPOSE,1.5SQ.MM', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100035, NULL),
(20001, 36, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10036, '0244A0061', 'CONTACTOR POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100036, NULL),
(20001, 37, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10037, '0244A0084', 'CONTACTOR POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100037, NULL),
(20001, 38, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10038, '0244A0155', '3 POLE 300A CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100038, NULL),
(20001, 39, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10039, '0244A0167', 'CONTACTOR RELAY 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 71, NULL, NULL, '', '', 'Released', 100039, NULL),
(20001, 40, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10040, '0244A0496', 'CONTACTOR,110A,110VAC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100040, NULL),
(20001, 41, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10041, '0244A0586', 'DS PLUG 16AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 39, NULL, NULL, '', '', 'Released', 100041, NULL),
(20001, 42, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10042, '0244A0587', 'DS SOCKET 16AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100042, NULL),
(20001, 43, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10043, '0244A0658', 'HRC 16A HF', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100043, NULL),
(20001, 44, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10044, '0244A0665', 'HRC 200A SIZE I', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100044, NULL),
(20001, 45, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10045, '0244A0844', 'POWER CONTRACTORS 3 POLE AC CONTROL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100045, NULL),
(20001, 46, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10046, '0244A0858', 'CONTACTOR: 300 AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 7, NULL, NULL, '', '', 'Released', 100046, NULL),
(20001, 47, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10047, '0244A0928', 'CONTACTOR MNX45, 110V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 12, NULL, NULL, '', '', 'Released', 100047, NULL),
(20001, 48, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10048, '0244A0958', 'SIEMENS CONTACTOR,110VAC,3TF3200-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 6, NULL, NULL, '', '', 'Released', 100048, NULL),
(20001, 49, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10049, '0244A0960', 'SIEMENS CONTACTOR,415VAC,3TF3400-OARO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100049, NULL),
(20001, 50, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10050, '0244A0961', 'SlEMENS CONTACTOR,220VAC,3TF3400-OAMO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100050, NULL),
(20001, 51, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10051, '0244A0962', 'ACTUATOR,2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 6, NULL, NULL, '', '', 'Released', 100051, NULL),
(20001, 52, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10052, '0244A0964', 'SIEMENS CONTACTOR,220VAC,3TF4822-OAPO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100052, NULL),
(20001, 53, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10053, '0244A0965', 'SIEMENS CONTACTOR,110VAC,3TF4822-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100053, NULL),
(20001, 54, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10054, '0244A0968', 'SIEMENS CONTACTOR,110VAC,3TF5202-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 14, NULL, NULL, '', '', 'Released', 100054, NULL),
(20001, 55, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10055, '0244A0969', 'SIEMENS CONTACTOR,110VAC,3TF5600-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100055, NULL),
(20001, 56, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10056, '0244A0973', 'SIEMENS CONTACTOR,110VAC,3TF3010-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100056, NULL),
(20001, 57, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10057, '0244A0976', 'SIEMENS CONTACTOR,110VAC,3TH3022-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100057, NULL),
(20001, 58, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10058, '0244A1002', 'SIEMENS CONTACTOR,10A,110V,3TF3010-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100058, NULL),
(20001, 59, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10059, '0244A1005', 'SIEMENS CONTACTOR,16A,110V,3TF3110-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100059, NULL),
(20001, 60, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10060, '0244A1074', 'SIEMENS CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100060, NULL),
(20001, 61, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10061, '0244A1140', 'VACUUM CONTACTOR 820A 220V AC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100061, NULL),
(20001, 62, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10062, '0244F0093', 'POWER CONTACTOR 420 AMPS.WITH 110 VOLTS', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100062, NULL),
(20001, 63, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10063, '0248A0021', 'CONTACT, ELECTRICAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100063, NULL),
(20001, 64, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10064, '0248A0117', 'ADD ON BLOCK FOR D2 & F RANGE CONTACTORS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100064, NULL),
(20001, 65, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10065, '0248A0249', 'CONTACT KIT FOR 3 TF 50', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100065, NULL),
(20001, 66, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10066, '0248A0253', 'CONTACT SET FOR 3TF54', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4, NULL, NULL, '', '', 'Released', 100066, NULL),
(20001, 67, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10067, '0255A0654', '0CCB', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100067, NULL),
(20001, 68, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10068, '0256A0128', 'MCB,2 POLE,16AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100068, NULL),
(20001, 69, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10069, '0256A0131', 'MCB,2 POLE,32AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100069, NULL),
(20001, 70, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10070, '0256A0132', 'MCB,2 POLE,40AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100070, NULL),
(20001, 71, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10071, '0256A0215', 'MERLIN GERIN MCB 1POLE 2A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100071, NULL),
(20001, 72, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10072, '0256A0218', 'MERLIN GERIN MCB 1POLE 6A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100072, NULL),
(20001, 73, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10073, '0256A0220', 'MERLIN GERIN MCB 1POLE 16A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100073, NULL),
(20001, 74, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10074, '0256A0288', 'MERLIN GERIN RCBO 16A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100074, NULL),
(20001, 75, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10075, '0256A0290', 'MERLIN GERIN RCBO 25A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100075, NULL),
(20001, 76, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10076, '0256A0291', 'MERLIN GERIN RCBO 32A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100076, NULL),
(20001, 77, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10077, '0256A1517', '550A 3 POLE POWER CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100077, NULL),
(20001, 78, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10078, '0256A1529', '200AMPS MCCB WITH ROTARY HANDLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100078, NULL),
(20001, 79, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10079, '0257L0084', 'OIL SEAL, 52 MM, 40 MM, 7 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100079, NULL),
(20001, 80, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10080, '0274A0102', 'SPLIT PIN FOR VI MECHANISM OF LF', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100080, NULL),
(20001, 81, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10081, '0278A0025', 'DOOR FITTINGS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 100081, NULL),
(20001, 82, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10082, '0289A0067', 'CO GAS DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100082, NULL),
(20001, 83, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10083, '0291B0022', 'POWDER CLEANING', '', 'LIT', 'N', 'Toolkit Store', '', '', NULL, 22, NULL, NULL, '', '', 'Released', 100083, NULL),
(20001, 84, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10084, '0291D0018', 'MISCELLANEOUS ITEMS (Godrej LOCK 8 lever', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100084, NULL),
(20001, 85, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10085, '0344A0007', 'CONDENSER FOR POWER CIRCUITS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100085, NULL),
(20001, 86, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10086, '0356A0054', '\"MCB DISTRIBUTION BOARD,12 WAY WITH WIRI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 3, NULL, NULL, '', '', 'Released', 100086, NULL),
(20001, 87, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10087, '0358A0032', 'PLUG FOR ELECT. POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100087, NULL),
(20001, 88, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10088, '0358A0083', 'METAL CLAD PLUG 20A 3 P', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 166, NULL, NULL, '', '', 'Released', 100088, NULL),
(20001, 89, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10089, '0359A0016', 'HIGH POWER LED TORCH LIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 30, NULL, NULL, '', '', 'Released', 100089, NULL),
(20001, 90, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10090, '0362A0743', 'HALOGEN LAMP 500W', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 13, NULL, NULL, '', '', 'Released', 100090, NULL),
(20001, 91, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10091, '0365a0002', 'CALLING BELL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100091, NULL),
(20001, 92, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10092, '0367A0155', '160 WATT PROGRAMMABLE HOOTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 11, NULL, NULL, '', '', 'Released', 100092, NULL),
(20001, 93, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10093, '0380B0038', '\"LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100093, NULL),
(20001, 94, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10094, '0380B0038', 'LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100094, NULL),
(20001, 95, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10095, '0394A0058', 'ALUMINIUM FOIL TAPE SIZE 5 CM X 10 MTR.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 972, NULL, NULL, '', '', 'Released', 100095, NULL),
(20001, 96, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10096, '0401D0096', 'PRESSURE TRANSMITTER, 0 - 10 BAR FOR CO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100096, NULL),
(20001, 97, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10097, '0426A0254', 'PERISTALTIC PUMP / 2 /12000 ML / H', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100097, NULL),
(20001, 98, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10098, '0426D0048', 'CONDENSATE MONITOR,MAT.PVC,CONNECTION-', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100098, NULL),
(20001, 99, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10099, '0435a0004', 'BAR SOAP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 500, NULL, NULL, '', '', 'Released', 100099, NULL),
(20001, 100, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10100, '0439A0074', 'HYDRAULIC OPERATED HAND PALLET TROLLY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 3, NULL, NULL, '', '', 'Released', 100100, NULL),
(20001, 101, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10101, '0445A0128', '1.5 SQMM GREY CONTROL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100101, NULL),
(20001, 102, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10102, '0447A0856', '3Cx10 sq. mm 1.1 KV XLPE AL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100102, NULL),
(20001, 103, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10103, '0447A0859', '3Cx70 sq. mm 1.1 KV XLPE AL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100103, NULL),
(20001, 104, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10104, '0447A0897', '3C X 300SQMM 1.1KV ALU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100104, NULL),
(20001, 105, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10105, '0449A0018', 'CABLES,CONTROL FOR FIXED WIRING', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100105, NULL),
(20001, 106, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10106, '0449A0126', 'SINGLE CORE COPPER FLEXIBLE CABLE,1.5SQ', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100106, NULL),
(20001, 107, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10107, '0449A0381', 'CNTRL CABLE 2.5X4C 1KV CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100107, NULL),
(20001, 108, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10108, '0449A0381', 'CTRL CABLE,2.5X4CX1KV,CU,HRE,HRE SH,ARM', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100108, NULL),
(20001, 109, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10109, '0449A0384', 'CTRL CBL,1KV, CU,2.5X4C,SIL,GLS BRAID', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100109, NULL),
(20001, 110, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10110, '0449A0832', '24CX1.5 SQMM 1.1KVXLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100110, NULL),
(20001, 111, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10111, '0449A0834', '16Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100111, NULL),
(20001, 112, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10112, '0449A0838', '7Cx1.5 SQ.MM 1.1KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100112, NULL),
(20001, 113, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10113, '0449A0840', '4Cx2.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100113, NULL),
(20001, 114, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10114, '0449A0841', '4Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100114, NULL),
(20001, 115, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10115, '0449A0842', '3Cx2.5 SQ.MM 1.1KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100115, NULL),
(20001, 116, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10116, '0449A0842', '3Cx2.5sq. mm 1.1 KV XLPE AL CABLE', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100116, NULL),
(20001, 117, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10117, '0449A0843', '3Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100117, NULL),
(20001, 118, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10118, '0451B0027', 'HYD.HOSE ASSLY SWAGED   4MM    1/4BSP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100118, NULL),
(20001, 119, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10119, '0453A0049', 'CABLE FOR CABLE REELING DRUM,70 SQ.MM.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100119, NULL),
(20001, 120, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10120, '0453A0192', 'FLEXIBLE HT CABLE FOR 6.6KV', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100120, NULL),
(20001, 121, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10121, '0470A0610', 'PAD Locking Kit for E Stop switch', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 6, NULL, NULL, '', '', 'Released', 100121, NULL),
(20001, 122, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10122, '0479A0059', 'CTS 1500A CT & TOCB ABB DRIVE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100122, NULL),
(20001, 123, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10123, '0485A0256', '\"ELECTRONIC DIGITAL MOTOR PROTECTION REL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100123, NULL),
(20001, 124, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10124, '0485A0396', 'ELECTRONIC OVERCURRENT RELAY EOCR 3DM60', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100124, NULL),
(20001, 125, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10125, '0485A0455', 'MOELLER DC CONTROL RELAY 24VDC 2NO 2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100125, NULL),
(20001, 126, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10126, '0485A0456', 'MOELLER AC CONTROL RELAY 110VAC 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100126, NULL),
(20001, 127, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10127, '0485A0689', 'BOCR  - 3 DE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100127, NULL),
(20001, 128, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10128, '0485A1038', '0.5-60A SAMWHA EOCR-3DM2WRDUW', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100128, NULL),
(20001, 129, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10129, '0485A1040', '0.5-60A EOCR Type FMZ2WRDUW with E/F', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100129, NULL),
(20001, 130, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10130, '0486A2447', '7.5KW Motor for Hoist', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100130, NULL),
(20001, 131, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10131, '0486A4060', 'SPL MOTR;SCIM,SEW EURO DRIVE,4 KW', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100131, NULL),
(20001, 132, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10132, '0517A0072', 'SWITCH,PROXIMITY - NO TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 6, NULL, NULL, '', '', 'Released', 100132, NULL),
(20001, 133, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10133, '0530A0112', 'STRIPPEX HT TAPE HIGH TEMP. TAPE 25MMX0.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100133, NULL),
(20001, 134, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10134, '0530A0139', 'NO FIRE A - 18 IN 1 LTR.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100134, NULL),
(20001, 135, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10135, '0530A0161', 'SILICO SEAL : ( 7.25 OZ PACK)', '', 'BOT', 'N', 'Toolkit Store', '', '', NULL, 15, NULL, NULL, '', '', 'Released', 100135, NULL),
(20001, 136, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10136, '0530B0053', 'PRISM 406 for O-ring', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100136, NULL),
(20001, 137, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10137, '0535A0115', '\"THERMOMETER BULB DIA 6MM, 8MM, 10MM, 12', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100137, NULL),
(20001, 138, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10138, '0535A0474', 'TRUE-RMS METER FOR PRECISE MEASUREMENT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100138, NULL),
(20001, 139, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10139, '0546A1974', 'Drill M/C IFM  M 12 connector(EVC009)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100139, NULL),
(20001, 140, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10140, '0546G0037', 'SS TYPE 5 PIN PLUG 30A 500V FOR TEMP.MEA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100140, NULL),
(20001, 141, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10141, '0546P0073', 'INSTRUMENTATION SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100141, NULL),
(20001, 142, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10142, '0556A0144', '16 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100142, NULL),
(20001, 143, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10143, '0556A0145', '25 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100143, NULL),
(20001, 144, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10144, '0556A0146', '50 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100144, NULL),
(20001, 145, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10145, '0556A0995', 'COPPER SOCKET  (XLPE)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100145, NULL),
(20001, 146, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10146, '0556A0996', 'COPPER SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100146, NULL),
(20001, 147, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10147, '0556A1023', 'COPPER SOCKET HEAVY DUTY 50 SQ.MM.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100147, NULL),
(20001, 148, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10148, '0556A1035', 'SOCKET FOR CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100148, NULL),
(20001, 149, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10149, '0556A1036', 'PIN SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100149, NULL),
(20001, 150, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10150, '0556A1038', 'PIN SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 79, NULL, NULL, '', '', 'Released', 100150, NULL),
(20001, 151, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10151, '0556A1045', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 98, NULL, NULL, '', '', 'Released', 100151, NULL),
(20001, 152, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10152, '0556A1047', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 70, NULL, NULL, '', '', 'Released', 100152, NULL),
(20001, 153, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10153, '0556A1049', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100153, NULL),
(20001, 154, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10154, '0556A1069', 'COPPER SOCKET (XLPE) 70MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100154, NULL),
(20001, 155, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10155, '0556A1070', 'CU.SOCKET 95 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 186, NULL, NULL, '', '', 'Released', 100155, NULL),
(20001, 156, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10156, '0556A1071', 'CU. RING SOCKET50 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 49, NULL, NULL, '', '', 'Released', 100156, NULL),
(20001, 157, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10157, '0556A1073', 'CU.RING SOCKET 70 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 45, NULL, NULL, '', '', 'Released', 100157, NULL),
(20001, 158, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10158, '0565B0058', 'BRAKE SHOE COMPT.WITH LINING FOR 8\"DIA', '', 'PAA', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100158, NULL),
(20001, 159, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10159, '0579A1264', 'Polyuretane foam (PUF) seal', '', 'ML', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100159, NULL),
(20001, 160, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10160, '0579A1287', 'Solvent based cleaner Light duty Spray', '', 'ml', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100160, NULL),
(20001, 161, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10161, '0622A0898', 'PNEUMATIC HOSE 12.07.X 5 METER 20 KG.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100161, NULL),
(20001, 162, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10162, '0633A0104', 'CABLE TIE 100X2.5', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4600, NULL, NULL, '', '', 'Released', 100162, NULL),
(20001, 163, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10163, '0633A0105', 'TIE 188X4.8', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100163, NULL),
(20001, 164, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10164, '0633A0106', 'CABLE TIE 370X4.8', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100164, NULL),
(20001, 165, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10165, '0666A0079', 'TRANSFORMER OIL,E.H.V,AS PER IS:335,AL', '', 'LTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100165, NULL),
(20001, 166, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10166, '0782A0938', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100166, NULL),
(20001, 167, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10167, '0782A0939', 'M.I.CABLE, 4 CORE CELOX, TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100167, NULL),
(20001, 168, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10168, '0782A1332', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100168, NULL),
(20001, 169, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10169, '0782A1348', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100169, NULL),
(20001, 170, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10170, '0814A0005', 'BRAKE SHOE WITH LINING FOR 10\" DIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100170, NULL),
(20001, 171, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10171, '0814A0006', 'BRAKE SHOE WITH LINING FOR 13\" DIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100171, NULL),
(20001, 172, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10172, '0829A0093', 'HAND LEVER OPERATED GREASE GUN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100172, NULL),
(20001, 173, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10173, '0829A0095', 'VOLUME PUMP 10 KG FOR MANUAL LUBRICATION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100173, NULL),
(20001, 174, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10174, '0843A0003', 'REGULATOR FOR CEILING FAN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 16, NULL, NULL, '', '', 'Released', 100174, NULL),
(20001, 175, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10175, '0850A0012', 'PLICA CONDUIT 3/4\"LEAD COATED,HEAT & C', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100175, NULL),
(20001, 176, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10176, '0850A0013', 'PLICA CONDUIT 1\" LEAD COATED,HEAT & CO', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100176, NULL),
(20001, 177, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10177, '0853A0082', 'SWITCH & CIRCUIT BREAKER ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100177, NULL),
(20001, 178, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10178, '0853A0388', '2 32AMPS HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100178, NULL),
(20001, 179, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10179, '0853A0468', '2 HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100179, NULL),
(20001, 180, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10180, '0853A0471', 'ACTUATOR NORMAL(RED)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100180, NULL),
(20001, 181, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10181, '0853A0496', 'COIL FOR 3TF56 CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100181, NULL),
(20001, 182, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10182, '0853a0526', 'ACTUATOR,1NO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100182, NULL),
(20001, 183, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10183, '0853A0527', 'SIEMENS CONTACTOR,110VAC,3TF3400-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100183, NULL),
(20001, 184, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10184, '0853A0542', 'AUX.BLOCK WITH 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 8, NULL, NULL, '', '', 'Released', 100184, NULL),
(20001, 185, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10185, '0853A0594', ' PENDANT CONTROL STATION, MAKE: TELEMECA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100185, NULL),
(20001, 186, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10186, '0853A0684', '5PAK 100 US WITH 2N/O+2NC WITH 110V AC C', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100186, NULL),
(20001, 187, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10187, '0853O0028', 'SILICA GEL SOLID GLOSSY RTS 741', '', 'KG', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100187, NULL),
(20001, 188, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10188, '0858A0636', 'LOAD CELL 25 TON', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100188, NULL),
(20001, 189, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10189, '0870A0746', 'HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100189, NULL),
(20001, 190, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10190, '0870A0747', 'HP laserjet 305A Printer cartridge.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100190, NULL),
(20001, 191, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10191, '0870A0748', 'HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100191, NULL),
(20001, 192, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10192, '0870A0749', ' HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100192, NULL),
(20001, 193, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10193, '0877A0124', 'HRC FUSE SIZE 0,2AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 30, NULL, NULL, '', '', 'Released', 100193, NULL),
(20001, 194, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10194, '0877A0330', 'HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 224, NULL, NULL, '', '', 'Released', 100194, NULL),
(20001, 195, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10195, '0877A0332', 'HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100195, NULL),
(20001, 196, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10196, '0877A0333', 'HRC FUSE SIZE 0.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100196, NULL),
(20001, 197, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10197, '0877A0336', 'HRC FUSE SIZE 0.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 46, NULL, NULL, '', '', 'Released', 100197, NULL),
(20001, 198, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10198, '0877A0342', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 47, NULL, NULL, '', '', 'Released', 100198, NULL),
(20001, 199, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10199, '0877A0343', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 31, NULL, NULL, '', '', 'Released', 100199, NULL),
(20001, 200, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10200, '0877A0344', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100200, NULL),
(20001, 201, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10201, '0877A0463', '16 A  HRC FUSE BS TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 33, NULL, NULL, '', '', 'Released', 100201, NULL),
(20001, 202, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10202, '0877A0500', 'HRC FUSE 2 AMPERES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 60, NULL, NULL, '', '', 'Released', 100202, NULL),
(20001, 203, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10203, '0877A0737', 'HF FUSE 10A,SF90148,L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 120, NULL, NULL, '', '', 'Released', 100203, NULL),
(20001, 204, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10204, '0877A0738', 'HF FUSE 20 AMP SF90151 L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 18, NULL, NULL, '', '', 'Released', 100204, NULL),
(20001, 205, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10205, '0877A0739', 'HF FUSE 25A,SF90152,L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 30, NULL, NULL, '', '', 'Released', 100205, NULL),
(20001, 206, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10206, '0877B0037', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 50, NULL, NULL, '', '', 'Released', 100206, NULL),
(20001, 207, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10207, '0877B0041', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 35, NULL, NULL, '', '', 'Released', 100207, NULL),
(20001, 208, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10208, '0877B0043', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100208, NULL),
(20001, 209, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10209, '0877B0046', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100209, NULL),
(20001, 210, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10210, '0877B0049', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100210, NULL),
(20001, 211, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10211, '0910A1488', 'INPUT SHAFT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100211, NULL),
(20001, 212, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10212, '0910A2026', 'LT DRIVE OUTPUT SHAFT', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100212, NULL),
(20001, 213, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10213, '0929A0011', 'SEALANT TAPE  12MT. PER ROLL', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 168, NULL, NULL, '', '', 'Released', 100213, NULL),
(20001, 214, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10214, '0936A0107', 'PLUG & SOCKET BOARD 220V 20A SPN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 7, NULL, NULL, '', '', 'Released', 100214, NULL),
(20001, 215, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10215, '0936A0207', 'MOUNTING CHANNEL FOR ELEMEX,MCB.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100215, NULL),
(20001, 216, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10216, '0936A0279', '63 AMP DS PLUG AND SOCKET ,BOX MOUNTED', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100216, NULL),
(20001, 217, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10217, '0937A0039', 'CONTROL CABLE FOR INSTRUMENTATION-4 PAIR  0.8MM ', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100217, NULL),
(20001, 218, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10218, '0940A0015', 'CABLES FOR FESTOONING(4 SQ.MM.,1100 VOLT,4 CORE,FLEXIBLE)', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100218, NULL),
(20001, 219, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10219, '0940A0056', 'FESTOONING CABLE,10X3C,1KV,CU,EPR,CSP SH', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100219, NULL),
(20001, 220, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10220, '0940A0057', 'FESTOONING CABLE,6X3CX1KV,CU,EPR,CSP SH', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100220, NULL),
(20001, 221, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10221, '0940A0102', 'FESTOON CABLE,SCREENED, 4C X 2.5 SQ.MM', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100221, NULL),
(20001, 222, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10222, '0940A0103', 'CABLE,FLEX,Cu,PVC,2.5SQ.,MM X 4C, LAPP', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100222, NULL),
(20001, 223, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10223, '0940A0103', 'FLEX CABLE CU PVC 4CX2.5SQMM LAPP CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100223, NULL),
(20001, 224, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10224, '0954A0007', 'ELECTRODE 6013 MILD STEEL 4 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100224, NULL),
(20001, 225, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10225, '0954A0008', 'WELDING ELECT MILD STEEL 3.15 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100225, NULL),
(20001, 226, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10226, '0954A0009', 'WELDING ELECT MILD STEEL 2.5 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100226, NULL),
(20001, 227, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10227, '0954A0011', 'ELECTRODE 7018 LOW HYDROGEN 4 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100227, NULL),
(20001, 228, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10228, '0954A0012', 'WELDING ELECT LOW HYDROGEN 3.15 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100228, NULL),
(20001, 229, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10229, '0954A0013', 'ELECTRODE,AWS 7018,MEDIUM CARBON,2.5 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100229, NULL),
(20001, 230, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10230, '0957A0074', 'DURACELL PLUS AAA ALKALINE 1.5V BATTERY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 14, NULL, NULL, '', '', 'Released', 100230, NULL),
(20001, 231, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10231, '0957A0119', 'SIZE AA PENCIL CELL,1.5V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 297, NULL, NULL, '', '', 'Released', 100231, NULL);
INSERT INTO `t_stock_process_line` (`spid`, `sl`, `dt`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `pqty`, `qty`, `nqty`, `act`, `toloc`, `tosloc`, `sts`, `skid`, `rem`) VALUES
(20001, 232, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10232, '0958A0848', 'DURACELL PLUS, AA SIZE, 1.5 V.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 105, NULL, NULL, '', '', 'Released', 100232, NULL),
(20001, 233, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10233, '0959A0295', 'BATTERY GRADE SULPHURIC ACID', '', 'LTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100233, NULL),
(20001, 234, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10234, '0960a0094', 'BATTERY CHARGER, 2 NOS FLOAT CUM BOOST', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100234, NULL),
(20001, 235, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10235, '0983A0176', 'AXIAL FLOW FAN', '', 'nOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100235, NULL),
(20001, 236, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10236, '0996A0058', 'FR Jacket E3 grade-Small', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 18, NULL, NULL, '', '', 'Released', 100236, NULL),
(20001, 237, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10237, '0996A0059', 'FR Jacket E3 grade- Medium', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 100237, NULL),
(20001, 238, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10238, '0996A0060', 'FR Jacket E3 grade- Large', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 19, NULL, NULL, '', '', 'Released', 100238, NULL),
(20001, 239, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10239, '0996A0061', 'FR Jacket E3 grade- Ex Large', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100239, NULL),
(20001, 240, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10240, '0996A0062', 'FR Trouser E3 grade- Small', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100240, NULL),
(20001, 241, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10241, '0996A0063', 'FR Trouser E3 grade- Medium', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100241, NULL),
(20001, 242, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10242, '0996A0064', 'FR Trouser E3 grade-Large', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100242, NULL),
(20001, 243, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10243, '0996A0065', 'FR Trouser E3 grade- Ex Large', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100243, NULL),
(20001, 244, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10244, '0999A0333', '150 WATT METAL HALIDE LAMP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100244, NULL),
(20001, 245, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10245, '1041A4636', 'SP4 570A 1400V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100245, NULL),
(20001, 246, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10246, '1041A4723', 'RCNA-01 CONTROL NET ADAPTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100246, NULL),
(20001, 247, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10247, '1041A5472', 'Analogue I/O 16 chan', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100247, NULL),
(20001, 248, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10248, '1041A5482', 'DO module,8 channel, 24V DC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100248, NULL),
(20001, 249, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10249, '1047A1419', 'BUS CONNECTOR FOR PROFIBUS PG 12 MBIT/S', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100249, NULL),
(20001, 250, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10250, '1048A0216', 'RIGHT END CAP TERMINAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100250, NULL),
(20001, 251, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10251, '1072A0555', 'USB 3-I THRUSTER DISC BRAKE 400x30-50/6', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100251, NULL),
(20001, 252, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10252, '1072A1160', '19 inch brake liner', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100252, NULL),
(20001, 253, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10253, '1106A0005', '\"LIGHTING CONNECTOR       ,SIZE : 0.5  T', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1102, NULL, NULL, '', '', 'Released', 100253, NULL),
(20001, 254, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10254, '1106A0038', '0.08 TO 4 MM SQUARE SCREWLESS TERMINAL B', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 700, NULL, NULL, '', '', 'Released', 100254, NULL),
(20001, 255, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10255, '1138A0024', 'LIGHTING TRANSFORMER,25 KVA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100255, NULL),
(20001, 256, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10256, '1142A0259', 'MNX400 CONTACTOR CS94144', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 7, NULL, NULL, '', '', 'Released', 100256, NULL),
(20001, 257, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10257, '1142A0265', 'MNX110 CONTACTOR CS94137', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100257, NULL),
(20001, 258, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10258, '1156A0083', 'XD2PA22 ONE NOTCH 2 DIRECTION JOYSTICK', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100258, NULL),
(20001, 259, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10259, '1304A0613', '48 Port Switch', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100259, NULL),
(20001, 260, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10260, '1306A0288', 'S.Sleeve,40.0 mm shaft X 9.91 mm wide', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100260, NULL),
(20001, 261, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10261, '1306A0329', 'S.Sleeve,110.0 mm shaft X 12.93 mm wide', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100261, NULL),
(20001, 262, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10262, '1586A1068', 'Control Net Redundant Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100262, NULL),
(20001, 263, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10263, '1586A1069', 'EhterNet/IP Communication Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100263, NULL),
(20001, 264, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10264, '1586A1224', '24V DC, 8A POWER SUPPLY MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100264, NULL),
(20001, 265, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10265, '1586A1251', 'PROFIBUS CONNECTOR WITHOUT PG:', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100265, NULL),
(20001, 266, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10266, '1586A1533', 'Redundancy Module', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100266, NULL),
(20001, 267, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10267, '1615A0422', 'RG-6 Co-axial Cable.(Video Cable)', '', 'mtr', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100267, NULL),
(20001, 268, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10268, '1877A0048', 'CV6 COIL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100268, NULL),
(20001, 269, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10269, '1877A0324', 'GLAND PACKING-M/C-52NE7581', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100269, NULL),
(20001, 270, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10270, '1877A1181', 'OIL LEAKAGE KIT -(Common New)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100270, NULL),
(20001, 271, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10271, '1889A1390', 'POWER SUPPLY MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100271, NULL),
(20001, 272, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10272, '1889A1393', 'DIGITAL INPUT MODULE 32 DI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100272, NULL),
(20001, 273, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10273, '1889A1396', 'BUSTERMINAL FOR PROFIBUS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100273, NULL),
(20001, 274, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10274, '1889A1407', 'RELAY COUPLE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100274, NULL),
(20001, 275, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10275, '1889A1409', 'VALVE CONNECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100275, NULL),
(20001, 276, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10276, '1889A1413', 'POWER SUPPLY DC - SITOP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100276, NULL),
(20001, 277, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10277, '1889A1416', 'MAINS FILTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100277, NULL),
(20001, 278, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10278, '1889A1419', 'IND. PROXIMITY SWITCH', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100278, NULL),
(20001, 279, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10279, '2442A0022', 'PORTABLE HAND BLOWER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100279, NULL),
(20001, 280, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10280, '2746A0072', '4 core trailing cable for B-type T/C', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100280, NULL),
(20001, 281, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10281, '2746A0112', 'MODBUS CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100281, NULL),
(20001, 282, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10282, '3178A0113', 'SIMATIC NET, PROFIBUS OLM/G12 V4.0', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100282, NULL),
(20001, 283, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10283, '3178A0132', 'EhterNet/IP Communication Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100283, NULL),
(20001, 284, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10284, '3285A0023', 'CABIN FAN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100284, NULL),
(20001, 285, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10285, '5010A0252', 'SPHRICAL ROLLR BRG,22230 CC/W33,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100285, NULL),
(20001, 286, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10286, '5010A0332', 'SPHRICAL ROLLR BRG,23136 CCW33,STRAIGHT,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100286, NULL),
(20001, 287, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10287, '5010A0429', 'SPHRICAL ROLLR BRG;22334CCW33,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100287, NULL),
(20001, 288, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10288, '5010A0588', '24124CC/W33,STRAIGHT,120MM,200MM,80MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100288, NULL),
(20001, 289, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10289, '5013A0268', 'TAPER ROLLR BRG;33209,45MM,85MM,32MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100289, NULL),
(20001, 290, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10290, '5013A0322', 'TAPER ROLLR BRG', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100290, NULL),
(20001, 291, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10291, '5014A0090', 'EL SWCH;32A,1,DP SWITCH,HDP,230-250V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100291, NULL),
(20001, 292, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10292, '5036A0868', 'BEARING;SL 182928 ,NORMAL ,STEEL ,140 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100292, NULL),
(20001, 293, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10293, '5176A0052', 'WLKY TLKY SPR;PTT KEYPAD,MOTOROLA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100293, NULL),
(20001, 294, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10294, '5176A0091', 'BATTERY ,KENWOOD ,KNB 57L ,WALKIE TALKIE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100294, NULL),
(20001, 295, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10295, '5189A0018', 'ELECTRONIC INST,TESTNG & MSRNG,ELECTRIC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100295, NULL),
(20001, 296, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10296, '5189A0089', 'EL T&M INST', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100296, NULL),
(20001, 297, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10297, '5276A0028', 'SFTWR;KEPWARE,KEPWARE MODBUS OPC SUITE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100297, NULL),
(20001, 298, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10298, '5288A0049', 'SFTY SHOE;10IN,BLACK', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100298, NULL),
(20001, 299, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10299, '5288A0050', 'SFTY SHOE;9,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100299, NULL),
(20001, 300, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10300, '5288A0055', 'SFTY SHOE;8IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100300, NULL),
(20001, 301, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10301, '5288A0056', 'SFTY SHOE;7IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4, NULL, NULL, '', '', 'Released', 100301, NULL),
(20001, 302, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10302, '5288A0057', 'SFTY SHOE;6IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 3, NULL, NULL, '', '', 'Released', 100302, NULL),
(20001, 303, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10303, '5288A0065', 'SFTY SHOE;5IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100303, NULL),
(20001, 304, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10304, '5309A1110', 'FRMC OVL ICU SXGA+ ,BARCO NOS,LARGE VIDE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100304, NULL),
(20001, 305, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10305, '5309A1112', 'UN OVL ENGINE Y T3 ,BARCO NOS,LARGE VIDE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100305, NULL),
(20001, 306, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10306, '5309A1452', 'SPEAKERPHONE  ,SENNHEISER  ,LAPTOP  ,HP/', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100306, NULL),
(20001, 307, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10307, '5309A1749', '32\" CURVE TFT ,HP ,DISPLAY MONITOR ,HP ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100307, NULL),
(20001, 308, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10308, '5309A1855', 'WIRELESS BLUETOOTH HEADPHONE  ,BOAT  ,LA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100308, NULL),
(20001, 309, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10309, '5320A0776', 'OIL SEAL;HIGH NITRILE RUBBER,45MM,62MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100309, NULL),
(20001, 310, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10310, '5320A1316', 'OIL SEAL;NBR ,140 MM,170 MM,12 MM,120 Â°C', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100310, NULL),
(20001, 311, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10311, '5322A0042', 'WIRELESS GTWY;ANTENNA ,USIT ,USIT-ASL-10', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100311, NULL),
(20001, 312, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10312, '5322A0067', 'WIRELESS GTWY;RF DATA TRANSMISSION ,PHOE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100312, NULL),
(20001, 313, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10313, '5355A0003', '11KV ELECT INSULATING MAT', '', 'ROLL', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100313, NULL),
(20001, 314, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10314, '5362A0028', 'PT;33/v3 KV,110/V3V,1,CAST RESIN,INDOOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100314, NULL),
(20001, 315, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10315, '5378A0005', 'O-RING CORD,NBR,5.7MM,72SHORE A,120Â¬C,NO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100315, NULL),
(20001, 316, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10316, '5387A0001', 'PRSE KNT HND GL;8', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100316, NULL),
(20001, 317, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10317, '5387A0002', 'PRSE KNT HND GL;Knitted hand gloves 12\"', '', 'PAA', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100317, NULL),
(20001, 318, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10318, '5434A0068', 'PAINT;PAINTING,ENAMEL,RED,4L TIN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100318, NULL),
(20001, 319, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10319, '5434A0070', 'PAINT;PAINTING,ENAMEL,GOLDEN YELLOW', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100319, NULL),
(20001, 320, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10320, '5437A0012', 'SWTCH NTWRK;1000MBPS,24NOS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100320, NULL),
(20001, 321, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10321, '5455A0580', 'HYD. HAND PUMP WITH PRE. GAUGE  ,ENERPAC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100321, NULL),
(20001, 322, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10322, '5483A0040', 'INSLTG TPE;ADHESIVE PVC  ,1.1  KV,GREEN', '', 'nOS', 'N', 'Toolkit Store', '', '', NULL, 291, NULL, NULL, '', '', 'Released', 100322, NULL),
(20001, 323, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10323, '5490A0241', 'WEGHNG M/C ACC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100323, NULL),
(20001, 324, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10324, '5495A0160', 'CNTRLR;MASTER CONTROLLER,220VAC,DIGITAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100324, NULL),
(20001, 325, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10325, '5502A0271', 'CPLNG SPR,SPIDER,L225,LOVEJOY,FLEXIBLE,N', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100325, NULL),
(20001, 326, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10326, '5507A0023', 'BRAKE;160MM,ELECTROMAGNETIC,DRUM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100326, NULL),
(20001, 327, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10327, '5507A0038', 'BRAKE;150MM,ELECTROMAGNETIC,DRUM', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100327, NULL),
(20001, 328, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10328, '5508A0110', 'ENCODER;HOLLOW SHAFT INC ENCODER,KUBLER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100328, NULL),
(20001, 329, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10329, '5509A0316', 'MCCB;32A,3,415V,50KA,AC,50HZ,1NO+1NC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100329, NULL),
(20001, 330, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10330, '5512A0090', 'SPR LOAD CEL;SARTORIUS,PR 6201/15N', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100330, NULL),
(20001, 331, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10331, '5513A0010', '7 SEG DSPLY;LED,RED,4,RED,100MM,190MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100331, NULL),
(20001, 332, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10332, '5521A0322', 'BRAKE SHOE WITH LINER ,SIBRE ,SIBRE ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100332, NULL),
(20001, 333, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10333, '5523A0094', 'FAN;CABIN,AC,1,230V,WALL,50HZ,400MM,4', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100333, NULL),
(20001, 334, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10334, '5523A0145', 'FAN;HEAVY DUTY AXIAL FLOW FAN ,AC ,SINGL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100334, NULL),
(20001, 335, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10335, '5527A0014', 'FLXBL CNDUIT,2\",PVC,FLEXIBLE,NO ACCESSOR', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100335, NULL),
(20001, 336, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10336, '5531A0257', 'CRANE ACCES,CURRENT COLLECTOR,ESI,CI-9,G', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100336, NULL),
(20001, 337, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10337, '5531A0293', 'CRANE ACCES;CARBON BRUSH,VAHLE,102980', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100337, NULL),
(20001, 338, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10338, '5531A0448', 'OPERATOR CHAIR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100338, NULL),
(20001, 339, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10339, '5531A0791', 'CRANE DSL INSULATOR  ,VAHLE  ,VDB 45 PHA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100339, NULL),
(20001, 340, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10340, '5539A0029', 'BAT CHRGR;SMF,FLOAT CUM BOOST,NO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100340, NULL),
(20001, 341, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10341, '5540A0328', 'ELECTRONIC CARD PLC PROFIBUS CABLE SEIMENS', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100341, NULL),
(20001, 342, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10342, '5542A0100', 'DRV SPR,FAN,ABB,64650424,ABB DRIVE,ABB,D', '', 'nOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100342, NULL),
(20001, 343, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10343, '5542A0280', 'DRV SPR;PULSE COUNTER,ABB,RTAC-01', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100343, NULL),
(20001, 344, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10344, '5542A1157', 'DRIV SPR;CONTROL UNIT CU 310 2 DP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100344, NULL),
(20001, 345, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10345, '5542A2070', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100345, NULL),
(20001, 346, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10346, '5542A2097', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100346, NULL),
(20001, 347, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10347, '5542A2761', 'COOLING FAN ,SCHNEIDER ,ATV71HC28N4 ,VZ3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 7, NULL, NULL, '', '', 'Released', 100347, NULL),
(20001, 348, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10348, '5544A2381', 'BOLT ;HEX HEAD,10MM,30MM,80,SS304', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100348, NULL),
(20001, 349, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10349, '5544A3661', 'BOLT:HEX HEAD 20, MM, 150 MM, SS304', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100349, NULL),
(20001, 350, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10350, '5553A0260', 'CAPACITOR;POLYPROPYLENE,6ÂµF,415V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100350, NULL),
(20001, 351, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10351, '5554A0039', 'LNGT TRF;50 KVA,5% IN 2.5% STEP ,ANAN ,F', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100351, NULL),
(20001, 352, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10352, '5555A0062', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,230 V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100352, NULL),
(20001, 353, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10353, '5555A0071', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,240 V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100353, NULL),
(20001, 354, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10354, '5557A0037', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC-', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100354, NULL),
(20001, 355, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10355, '5558A0035', 'HYD JACK;50TON,150MM,SINGLE ACTING', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100355, NULL),
(20001, 356, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10356, '5563A0915', 'SPARE;COPPER DISC,LADLE FURNACE,LD1', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100356, NULL),
(20001, 357, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10357, '5566A0059', 'CCTV CAM;5MP', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100357, NULL),
(20001, 358, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10358, '5575A0069', 'RCBO;25 A,4 ,415 V,300 MA,C ,50 HZ,50 Â°C', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100358, NULL),
(20001, 359, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10359, '5582A0014', 'VCB;1250A,3,36000V,DRAW OUT TYPE,SHUNT', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100359, NULL),
(20001, 360, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10360, '5582A0039', 'VCB;1250 A,3 ,6600 V,DRAW OUT TYPE ,50 H', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100360, NULL),
(20001, 361, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10361, '5593A0077', 'TEMP TRNTR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100361, NULL),
(20001, 362, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10362, '5593A0099', 'TEMP TRNTR;2 WIRE TEMPERATURE TRANSMITTE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100362, NULL),
(20001, 363, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10363, '5607A0666', 'RELAY;ELECTROMECHANICAL,CONTROL CIRCUIT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100363, NULL),
(20001, 364, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10364, '5607A0671', 'RELAY;ELECTRONIC,IR MEASUREMENT,+/-1%', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100364, NULL),
(20001, 365, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10365, '5607A1125', 'RELAY;ELECTRONIC OVERCURRENT RELAY ,MOTO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100365, NULL),
(20001, 366, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10366, '5607A1297', 'RELAY;ELECTROMAGNETIC ,MAGNET UNDERCURRE', '', 'nOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100366, NULL),
(20001, 367, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10367, '5613A0186', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100367, NULL),
(20001, 368, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10368, '5613A0187', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100368, NULL),
(20001, 369, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10369, '5613A0245', 'LMT SWTCH;SNAP ACTION,HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100369, NULL),
(20001, 370, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10370, '5620A0226', 'PLC SPR,EN RUSB CARD KIT DRIVEWINDOW 2.3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100370, NULL),
(20001, 371, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10371, '5620A0719', 'PLC SPR,PRBS KIT ULTRA PRO WTH OPC SRV,P', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100371, NULL),
(20001, 372, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10372, '5620A0987', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100372, NULL),
(20001, 373, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10373, '5620A1046', 'PLC SPR;ANALOG INPUT MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100373, NULL),
(20001, 374, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10374, '5620A1051', 'PLC SPR;REDUNDANCY MODULE,ALLEN BRADLEY', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100374, NULL),
(20001, 375, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10375, '5620A2359', 'ETHERNET MODULE ,CONTROL LOGIX ,1756-EN2', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100375, NULL),
(20001, 376, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10376, '5620A2360', 'CONTROLNET MODULE ,CONTROL LOGIX ,1756-C', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100376, NULL),
(20001, 377, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10377, '5620A2361', 'REDUNDANCY MODULE ,CONTROL LOGIX ,1756-R', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100377, NULL),
(20001, 378, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10378, '5620A2859', 'HMI DISPLAY UNIT ,IBA ,91.000032 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100378, NULL),
(20001, 379, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10379, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN B', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100379, NULL),
(20001, 380, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10380, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN BR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100380, NULL),
(20001, 381, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10381, '5620A4261', 'IBARACKLINE SAS, XEON E, WIN10 ,IBA ,40.', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100381, NULL),
(20001, 382, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10382, '5623A0361', 'MOTOR&ACCES;FIELD COIL,ABB', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100382, NULL),
(20001, 383, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10383, '5623A0787', 'TACHO WITH OVER SPEED ,HUBNER-GERMANY ,F', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100383, NULL),
(20001, 384, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10384, '5623A1254', 'BRAKE UNIT ,NORD ,BRE150 HL ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100384, NULL),
(20001, 385, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10385, '5631A0004', 'INST CLNG FAN,AC,230V,250MM,50 HZ,115 W', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100385, NULL),
(20001, 386, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10386, '5633A0007', 'RGD CNDUIT,1-1/2INCH,GI,HEAT & CORROSION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100386, NULL),
(20001, 387, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10387, '5641A0160', 'SLCTR SW;6 A,10 WAY 3POSITION STAYPUT ,1', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100387, NULL),
(20001, 388, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10388, '5641a0198', 'selector switch', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100388, NULL),
(20001, 389, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10389, '5641A0198', 'SLCTR SW;10 A,4 POSITION SELECTOR WITH O', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100389, NULL),
(20001, 390, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10390, '5669A0400', 'LFT SPR;INVRTR TKE-1-18.5 7.5KW OL/CL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100390, NULL),
(20001, 391, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10391, '5669A0983', 'DOOR SENSOR (IR SCREEN) ,THYSSENKRUPP ,L', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100391, NULL),
(20001, 392, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10392, '5669A1591', 'THIMBLE ROD ,OTIS ,LIFT ,OTIS ELEVATORS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100392, NULL),
(20001, 393, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10393, '5669A1661', '41 TYPE LOCK RH[NOA6694B2] ,OTIS ,LIFT ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100393, NULL),
(20001, 394, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10394, '5669A1991', 'DOOR WIRE CORD ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100394, NULL),
(20001, 395, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10395, '5669A2015', 'CAR GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100395, NULL),
(20001, 396, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10396, '5669A2016', 'CWT GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100396, NULL),
(20001, 397, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10397, '5681A0070', 'LIFTNG SHKL;12.5 TON,8 ,35.5 mm', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100397, NULL),
(20001, 398, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10398, '5684A0072', 'SPL LGHT;EMERGENCY,YES,PORTABLE,220VAC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100398, NULL),
(20001, 399, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10399, '5684A0190', 'SPL LGHT;RECHARGEABLE EMERGENCY LAMP ,YE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100399, NULL),
(20001, 400, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10400, '5694A0470', 'NO SPECIAL FEATURES ,CUTTING DISC ,BOSCH', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100400, NULL),
(20001, 401, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10401, '5700A0854', 'FLD SNSR;OPTICAL DISTANCE SENSOR(LASER)', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100401, NULL),
(20001, 402, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10402, '5700A0946', 'FLD SNSR;Vibration Sensor ,BENTALY NAVAD', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100402, NULL),
(20001, 403, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10403, '5701A0088', 'ELECT SOCKT/PLG;32A,METALLIC,5,PLUG', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100403, NULL),
(20001, 404, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10404, '5701A0093', 'ELECT SOCKT/PLG;125A,METALLIC,5,PLUG', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 22, NULL, NULL, '', '', 'Released', 100404, NULL),
(20001, 405, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10405, '5701A0095', 'ELECT SOCKT/PLG;32A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100405, NULL),
(20001, 406, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10406, '5701A0096', 'ELECT SOCKT/PLG;63A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4, NULL, NULL, '', '', 'Released', 100406, NULL),
(20001, 407, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10407, '5701A0097', 'ELECT SOCKT/PLG;125A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100407, NULL),
(20001, 408, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10408, '5701A0100', 'ELECT SOCKT/PLG;63A', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100408, NULL),
(20001, 409, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10409, '5701A0141', 'EL SKT/PLG;20A,METAL CLAD,3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100409, NULL),
(20001, 410, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10410, '5701A0142', 'EL SKT/PLG;20A,METAL CLAD,2,SOCKET,230V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100410, NULL),
(20001, 411, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10411, '5715A0462', 'OMEGA 904  ,MAGNA  ,OMEGA 904  ,5  LITER', '', 'LIT', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100411, NULL),
(20001, 412, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10412, '5715A0599', 'SEAL LEAK PROOF OIL ,OMEGA ,OMEGA 917 ,5', '', 'LIT', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100412, NULL),
(20001, 413, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10413, '5717A0048', 'LT CABLE 16CX2.5MMSQ TINNED COPPER ELASTOMER', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100413, NULL),
(20001, 414, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10414, '5717A0366', 'LT CABLE 12CX2.5SQMM TINNED COPPER', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100414, NULL),
(20001, 415, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10415, '5717A0467', 'LT CBL;6,6MM2,COPPER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100415, NULL),
(20001, 416, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10416, '5717A0910', 'LT CBL;8 ,PVC-ST2-FRLSH ,ANNEALED BARE C', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100416, NULL),
(20001, 417, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10417, '5717A1002', 'LT CBL;2 ,CSP-FRLSH ,ANNEALED TINNED COP', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100417, NULL),
(20001, 418, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10418, '5717A1014', 'LT CBL;4 ,CSP-FRLSH ,ANNEALED TINNED COP', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100418, NULL),
(20001, 419, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10419, '5739A0008', 'TIMER;ELECTRONIC MULTIMODE TIMER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100419, NULL),
(20001, 420, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10420, '5748A0181', 'FUSE,FLUKE MULTIMETER FUSE,440MA,1000V,3', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4, NULL, NULL, '', '', 'Released', 100420, NULL),
(20001, 421, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10421, '5748A0609', 'FUSE;HRC,400A,500V,120KA,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 25, NULL, NULL, '', '', 'Released', 100421, NULL),
(20001, 422, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10422, '5748A0730', 'FUSE;SEMICONDUCTOR,1100A,1000V,100KA,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100422, NULL),
(20001, 423, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10423, '5751A0049', 'ALCOHOL RUBIN STERILE HAND DIS ,500 ML,N', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100423, NULL),
(20001, 424, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10424, '5761A0136', 'ELECT BOX;JUNCTION BOX,UP TO 1.1KV,WALL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100424, NULL),
(20001, 425, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10425, '5761A0316', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100425, NULL),
(20001, 426, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10426, '5761A0317', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100426, NULL),
(20001, 427, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10427, '5761A0318', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100427, NULL),
(20001, 428, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10428, '5761A0319', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100428, NULL),
(20001, 429, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10429, '5761A0320', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100429, NULL),
(20001, 430, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10430, '5761A0321', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100430, NULL),
(20001, 431, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10431, '5761A0322', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100431, NULL),
(20001, 432, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10432, '5761A0323', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100432, NULL),
(20001, 433, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10433, '5761A0326', 'EL BOX;GROUNDING POINT NOT REQUIRE ,JUNC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100433, NULL),
(20001, 434, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10434, '5772A0143', 'PUSH BTN;PB STATION ,GREEN ,TEKNIC ,FLUS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100434, NULL),
(20001, 435, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10435, '5772A0144', 'PUSH BTN;FLUSH MOUNTED P.B ,GREEN ,TEKNI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100435, NULL),
(20001, 436, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10436, '5772A0185', 'PUSH BTN;PUSH BUTTON ACTUATOR ,GREEN ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100436, NULL),
(20001, 437, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10437, '5772A0310', 'PUSH BTN;PUSH BUTTON ACTUATOR ,BLUE ,TEK', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100437, NULL),
(20001, 438, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10438, '5775A0005', 'LV HAND GLOVES;9 ,', '', 'PAA', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100438, NULL),
(20001, 439, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10439, '5789A0075', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 3, NULL, NULL, '', '', 'Released', 100439, NULL),
(20001, 440, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10440, '5789A0076', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100440, NULL),
(20001, 441, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10441, '5789A0077', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100441, NULL),
(20001, 442, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10442, '5789A0102', 'OFFC ACCS;WIRELESS MOUSE {HP X3500}', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100442, NULL),
(20001, 443, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10443, '5789A0192', 'UMBRELLA WITH WOODEN HANDLE ,ANY ,UMBREL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 4, NULL, NULL, '', '', 'Released', 100443, NULL),
(20001, 444, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10444, '5794A0309', 'CBL SCKT;PIN,1.5MM2,COPPER,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100444, NULL),
(20001, 445, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10445, '5794A0310', 'CBL SCKT;PIN,2.5MM2,COPPER,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100445, NULL),
(20001, 446, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10446, '5803A1238', 'SPL HOSE;HYDRAULIC HOSE 6\" LONG ,HC7206', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100446, NULL),
(20001, 447, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10447, '5811A1619', 'GEAR COUPLING 2 ,LD#1 ,CRANE ,AS PER DRA', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100447, NULL),
(20001, 448, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10448, '5811A2507', 'CRANE SHAFT ,LD#1 ,CRANE ,AS PER DRAWING', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100448, NULL),
(20001, 449, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10449, '5811A3304', 'HG 1050 INPUT PINION SHAFT  ,LD#1  ,BOF', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100449, NULL),
(20001, 450, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10450, '5811A4473', 'HG 1050 2ND INTERMEDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100450, NULL),
(20001, 451, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10451, '5811A4474', 'HG 1050 2ND GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100451, NULL),
(20001, 452, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10452, '5811A4475', 'HG 1050 1ST GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100452, NULL),
(20001, 453, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10453, '5811A4476', 'HG 1050 1ST INTERMEDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100453, NULL),
(20001, 454, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10454, '5811A4477', 'HG 1050 INPUT PINION SHAFT ,LD1 ,VESSEL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100454, NULL),
(20001, 455, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10455, '5811A4486', 'HG 1050 3RD INTERMIDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100455, NULL),
(20001, 456, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10456, '5811A4487', 'HG 1050 3RD GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100456, NULL),
(20001, 457, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10457, '5811A4497', 'HG 1050 4TH GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100457, NULL);
INSERT INTO `t_stock_process_line` (`spid`, `sl`, `dt`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `pqty`, `qty`, `nqty`, `act`, `toloc`, `tosloc`, `sts`, `skid`, `rem`) VALUES
(20001, 458, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10458, '5811A4675', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100458, NULL),
(20001, 459, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10459, '5811A4676', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100459, NULL),
(20001, 460, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10460, '5845A0109', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100460, NULL),
(20001, 461, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10461, '5845A0112', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100461, NULL),
(20001, 462, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10462, '5847A0306', 'WIRE ROPE;28 MM,RHO ,1770 N/MM2,150 M RO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100462, NULL),
(20001, 463, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10463, '5847a0340', 'WIRE ROPE;22 MM,RHO ,1770 N/MM2,100 M RO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100463, NULL),
(20001, 464, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10464, '5847a0351', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100464, NULL),
(20001, 465, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10465, '5848A0002', 'POWR TESTR;HT POWER TESTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100465, NULL),
(20001, 466, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10466, '5849A0049', 'CNDTR;CU-AL BIMETALLIC SHEET ,COPPER CLA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100466, NULL),
(20001, 467, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10467, '5854A0035', 'SAFE;FIRE RETARDANT,XXXL,ORANGE,BLUE,NA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100467, NULL),
(20001, 468, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10468, '5859A0004', 'INSULATING MATL,TAPE,TOUGARD,10MX5CM,0,P', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100468, NULL),
(20001, 469, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10469, '5859A0120', 'INSULATING MATL,SHEET,FIBRE INSULATOR,73', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100469, NULL),
(20001, 470, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10470, '5859A0298', 'INSULATING MATL;TAPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100470, NULL),
(20001, 471, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10471, '5859A0315', 'INSULATING MATL;SLEEVE', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100471, NULL),
(20001, 472, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10472, '5867A0345', 'CRBN BRS;EG14 ,VINAYAK CARBON ,CARBON BR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100472, NULL),
(20001, 473, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10473, '5870A1809', 'MATL PROJCT;Spike BusterSET', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100473, NULL),
(20001, 474, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10474, '5872A0113', 'SW GR&CB SPR,CONTACT KIT,BCH,CONTACTOR,9', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100474, NULL),
(20001, 475, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10475, '5872A0418', 'SW GR&CB SPR,AUX CONTACT,ABB,CONTACTOR,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100475, NULL),
(20001, 476, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10476, '5872A1298', 'SW GR&CB SPR,PANEL KEY,PRECISION SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100476, NULL),
(20001, 477, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10477, '5872A1709', 'SW GR&CB SPR,PAD LOCKING KIT,SCNEDR ELEC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100477, NULL),
(20001, 478, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10478, '5872A2046', 'S/GR SPR;MECH ASMBLY OF VAC INTERRUPTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100478, NULL),
(20001, 479, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10479, '5872A2047', 'S/GR SPR;VACCUM INTERRUPTER (BOTTLE)', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100479, NULL),
(20001, 480, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10480, '5872A2197', 'CLOSE CASTING PENDANT ,SMS CONCAST ,MOUL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100480, NULL),
(20001, 481, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10481, '5872A2273', 'DC CONTACT TIP FIXED ,NA ,900 A GE TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100481, NULL),
(20001, 482, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10482, '5872A2279', 'SURGE PROTECTION DEVICE( 24 ,DEHN ,OPACI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100482, NULL),
(20001, 483, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10483, '5872A2283', 'DC CONTACT TIP MOVING ,GE ,900 A GE TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100483, NULL),
(20001, 484, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10484, '5885A0282', 'PROXIMITY;ANALOG PROXIMITY SWITCH,0-4MM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100484, NULL),
(20001, 485, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10485, '5885A0289', 'PROXMTY;INDUCTIVE SENSOR,20MM,10-30V', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100485, NULL),
(20001, 486, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10486, '5885A0326', 'PROXMTY;INDUCTIVE,4MM,10-30V,IP68', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100486, NULL),
(20001, 487, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10487, '5890A0715', 'CONTCR;110A,3,110V,POWER,415V,S6,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100487, NULL),
(20001, 488, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10488, '5890A0723', 'CONTCR;140A,3,110V,POWER,415V,S6,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100488, NULL),
(20001, 489, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10489, '5890a0734', 'CONTCOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100489, NULL),
(20001, 490, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10490, '5890A0854', 'CONTCR;70A,3,110V,POWER,415V,8,AC,50HZ', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100490, NULL),
(20001, 491, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10491, '5890A0969', 'CNTCR;900 A,1 ,220 V,DC ,660 V,DC ,2NO+2', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100491, NULL),
(20001, 492, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10492, '5890A1027', 'CNTCR;20 A,2 NOS,240 VAC,DC ,415 V,SIZE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100492, NULL),
(20001, 493, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10493, '5890A1070', 'CNTCR;300 A,3 ,220 V,POWER ,415 V,S10 ,A', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100493, NULL),
(20001, 494, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10494, '5893A0420', 'CONTACT PAD COPPER RING ,PRECISION SPARE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100494, NULL),
(20001, 495, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10495, '5899A0046', 'HAND  WASING PASTE', '', 'kg', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100495, NULL),
(20001, 496, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10496, '5899A0069', 'AUTOMATIC SOAP DISPENSER  ,NA  ,NOT APPL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100496, NULL),
(20001, 497, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10497, '5900A2144', 'AC MOTR;0.18 KW,415 Â± 10% V,SQUIRREL CAG', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100497, NULL),
(20001, 498, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10498, '5900A3424', 'AC MOTR;IE2 ,0.25 KW,415 Â± 10% V,SQUIRRE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100498, NULL),
(20001, 499, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10499, '5900A3570', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100499, NULL),
(20001, 500, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10500, '5900A3653', 'AC MOTR;IE2 ,3.7 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100500, NULL),
(20001, 501, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10501, '5900A3927', 'AC MOTR;IE2 ,7.5 KW,390 +10%/-10% V,SQUI', '', 'nOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100501, NULL),
(20001, 502, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10502, '5905A0003', 'P ISLN;POSITIVE ISO PAD LOCK YELLOW', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100502, NULL),
(20001, 503, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10503, '5914A0169', 'SHOE POLISH,STANDARD,HEAVY METAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100503, NULL),
(20001, 504, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10504, '5918A1049', 'GRINDING MACHINE ,DEWALT ,DW801-B1 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100504, NULL),
(20001, 505, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10505, '5924A0116', 'SPL MOTR;LINEAR ACTUATOR FOR CC1', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100505, NULL),
(20001, 506, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10506, '5924A0268', 'SPL MOTR;CIRCULATION PUMP ,BEACON WEIR L', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100506, NULL),
(20001, 507, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10507, '5924A0278', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100507, NULL),
(20001, 508, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10508, '5924A0378', 'SPL MOTR;0.23 KW 2800 RPM UNBLCE MOTOR ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100508, NULL),
(20001, 509, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10509, '5924A0636', 'SPL MOTR;STOPPER MECHANISM COMPLETE ,SMS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100509, NULL),
(20001, 510, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10510, '5924A0681', 'SPL MOTR;HYDRAULIC PUMP MOTOR ,SIEMENS ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100510, NULL),
(20001, 511, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10511, '5929A0003', 'BRAK MTR;BRAKE MOTORS,0.37KW', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100511, NULL),
(20001, 512, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10512, '5929A0046', 'BRAK MOTR;CARRIAGE MOTOR ,1.1 KW,SMS CON', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100512, NULL),
(20001, 513, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10513, '5953A0075', 'FIVE SLOT CABLE PROTECTOR UNIT,STANDARD', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100513, NULL),
(20001, 514, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10514, '5956A0522', 'INST SPR;MOULD LEVEL DETECTOR CC2/CC3', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100514, NULL),
(20001, 515, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10515, '5956A0633', 'INST SPR;VIBRATION SENSOR VERTICAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100515, NULL),
(20001, 516, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10516, '5956A0634', 'INST SPR;VIBRATION SENSOR HORIZONTAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100516, NULL),
(20001, 517, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10517, '5956A0680', 'INST SPR;Contact Block for temp S 2 Co', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100517, NULL),
(20001, 518, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10518, '5956A0929', 'INST SPR;SIGNAL ISOLATOR,MASIBUS', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100518, NULL),
(20001, 519, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10519, '5956A0930', 'INST SPR;CONTACT BLOCK FOR TEMP B 2 COR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 30, NULL, NULL, '', '', 'Released', 100519, NULL),
(20001, 520, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10520, '5956A1492', 'INST SPR TEMP & OXY MEASUREMENT PROBEF', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100520, NULL),
(20001, 521, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10521, '5956A2043', 'SCINTILLATION COUNTER ,BERTHOLD TECHNOLO', '', 'SET', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100521, NULL),
(20001, 522, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10522, '5958A0019', 'CONT BLK;ELECTRICAL PANEL,TEKNIC,NO,1', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100522, NULL),
(20001, 523, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10523, '5964A0171', 'PNL;WELDING MACHINE SAFETY PANEL ,450X44', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100523, NULL),
(20001, 524, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10524, '5964a0196', 'PNL;RIO PANEL ,NO SPECIAL FEATURES ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100524, NULL),
(20001, 525, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10525, '5964A0209', 'PNL;CONTROL DESK WITHOUT HMI ,NO SPECIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100525, NULL),
(20001, 526, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10526, '5965A1903', 'BENCH GRINDER NOS,STGB 3715 ,STANLEY ,1/', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100526, NULL),
(20001, 527, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10527, '5968A0022', 'SPARE,ELECTRONIC;VGA TO HDMI CONVERTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100527, NULL),
(20001, 528, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10528, '5968A0023', 'SPARE,ELECTRONIC;HDMI Cable', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100528, NULL),
(20001, 529, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10529, '5971A0237', 'EPOXY BASED PROTECTIVE COATING ,LOCTITE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100529, NULL),
(20001, 530, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10530, '5995a0026', 'RAD ACT INST;CO-60 ROD SOURCE ,GAMMA RAY', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100530, NULL),
(20001, 531, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10531, '5995A0027', 'RAD ACT INST;SHIELDING FOR AMLC SOURCE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100531, NULL),
(20001, 532, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10532, '5997a0035', 'CONTROL STOP INDICATION SYSTEM ,BALAJI E', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100532, NULL),
(20001, 533, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10533, '6008A0002', 'N/W PASSIVE DEVICE FO CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100533, NULL),
(20001, 534, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10534, '6010A0001', 'N/W PASSIVE HDPE PIPE/DWC DUCT', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100534, NULL),
(20001, 535, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10535, '6015A0001', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100535, NULL),
(20001, 536, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10536, '6015A0002', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100536, NULL),
(20001, 537, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10537, '6021A0056', 'EL TSTG INST;CONTACT RESISTANCE MEASUREM', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100537, NULL),
(20001, 538, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10538, '6024A0040', 'HIGH TEMPERATURE ADHESIVE TAPE ,50 MM,SA', '', 'RLL', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100538, NULL),
(20001, 539, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10539, '6028A0061', 'POWER DISTRIBUTION ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100539, NULL),
(20001, 540, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10540, '6028A0062', 'POWER DISTRIBUTION ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 1, NULL, NULL, '', '', 'Released', 100540, NULL),
(20001, 541, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10541, '6045A0002', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100541, NULL),
(20001, 542, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10542, '6045A0028', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100542, NULL),
(20001, 543, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10543, '6045A0136', 'SPL CBL;CABLES FOR SERVO MOTOR ,LAPP IND', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100543, NULL),
(20001, 544, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10544, '6045A0143', 'SPL CBL;RESOLVER CABLE FOR STOPPER BOX ,', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100544, NULL),
(20001, 545, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10545, '6045A0157', 'SPL CBL;ENCODER CONNECTOR WITH CABLE ,KU', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100545, NULL),
(20001, 546, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10546, '6049A0066', 'SPL INST;TEMPERATURE STICKER ,TEMPERATUR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100546, NULL),
(20001, 547, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10547, '6093A0007', 'LUMR;HIGHBAY,160W,AC,140 - 270V,NO,YES', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100547, NULL),
(20001, 548, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10548, '6093A0014', 'LUMR;WELL GLASS,29W,AC,140 - 270V,NO', '', 'Nos.', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100548, NULL),
(20001, 549, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10549, '6122A0082', 'CABLE ACCESSORIES;450  V,TYPE:U1K16  ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100549, NULL),
(20001, 550, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10550, '6125A0054', 'THZ WAVE RADAR LEVEL TRANSMITT ,PRIBUSIN', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100550, NULL),
(20001, 551, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10551, '6125A0058', 'SPD_230V SINGLE PHASE ,DEHN ,900351 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100551, NULL),
(20001, 552, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10552, '6128A0018', 'LARGE DIGITAL INDICATOR ,MASIBUS ,409-4I', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100552, NULL),
(20001, 553, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10553, '6130A0017', 'TEMPERATURE & HUMIDITY DISPLAY ,CASIO ,I', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100553, NULL),
(20001, 554, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10554, '6131A0024', 'DISPLAY FOR MAG FLOW ,YOKOGAWA ,F9802JA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100554, NULL),
(20001, 555, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10555, '6132A0805', 'SPARE VALVE STAND FOR HOOD PRS ,SATYATEK', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100555, NULL),
(20001, 556, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10556, '6142A0003', 'STP;KRAMER ,NOT APPLICABLE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100556, NULL),
(20001, 557, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10557, '6183A0009', 'MASTER CONTROLLER;220 VAC,10 A,4-0-4 ,BI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100557, NULL),
(20001, 558, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10558, '6183A0017', 'MASTER CONTROLLER;400 VAC/DC,16 A,4-0-4', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100558, NULL),
(20001, 559, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10559, '6183A0039', 'MASTER CONTROLLER;400 VAC/DC,10 A,1-0-1', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100559, NULL),
(20001, 560, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10560, '6186A0037', 'NW SPARES;LSZH PATCH CORD CAT6A , 10 M', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100560, NULL),
(20001, 561, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10561, '6186A0076', 'NW SPARES;WS-C3850X-12S-E CATALYST 3850X', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100561, NULL),
(20001, 562, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10562, '6186A0273', 'NW SPARES;6U WALL MOUNT NETWORK RACK WIT', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100562, NULL),
(20001, 563, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10563, '6186A0279', 'NW SPARES;6U FLOOR MOUNT OUTDOOR CABINE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100563, NULL),
(20001, 564, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10564, '6186A0297', 'NW SPARES;12 PORT LOADED FIBER LIU RACK', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 100564, NULL),
(20001, 565, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10565, '6186A0301', 'NW SPARES;FIBER OPTIC CABLE (6 CORE) MM', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100565, NULL),
(20001, 566, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10566, '6186A0310', 'NW SPARES;6 CORE SM FO CABLE,LOOSE TUBE', '', 'MTR', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100566, NULL),
(20001, 567, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10567, '6186A0317', 'NW SPARES;LC-SC FO PATCH CORD, DUPLEX, O', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100567, NULL),
(20001, 568, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10568, '6186A0326', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 2', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100568, NULL),
(20001, 569, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10569, '6186A0327', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 15', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100569, NULL),
(20001, 570, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10570, '6186A0328', 'NW SPARES;CAT 6A S/FTP CABLE (500 METER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100570, NULL),
(20001, 571, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10571, '6186A0331', 'NW SPARES;CAT6A STP PATCH CRD 2M LSZH ,N', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100571, NULL),
(20001, 572, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10572, '6186A0357', 'NW SPARES;SC PIGTAIL MM OM1 SIMPLEX LSZH', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100572, NULL),
(20001, 573, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10573, '6186A0359', 'NW SPARES;PATCH CRD;FIBER MULTIMODE DUPL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100573, NULL),
(20001, 574, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10574, '6186A0370', 'NW SPARES;SWITCH ,WS-C2960CX-8TC-L ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 100574, NULL),
(20001, 575, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10575, '6186A0371', 'NW SPARES;FIREWALL ,FORTIGATE 60E ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100575, NULL),
(20001, 576, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10576, '6204A0001', 'SHUNT FOR CONTACTOR;300 A,BRAIDED WIRE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100576, NULL),
(20001, 577, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10577, '5669A0441', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100577, NULL),
(20001, 578, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10578, '5669A0983', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100578, NULL),
(20001, 579, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10579, '5669A0566', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100579, NULL),
(20001, 580, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10580, '5669A1521', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100580, NULL),
(20001, 581, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10581, '5669A0895', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100581, NULL),
(20001, 582, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10582, '5669A1519', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100582, NULL),
(20001, 583, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10583, '5900A1468', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100583, NULL),
(20001, 584, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10584, '5900A1505', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100584, NULL),
(20001, 585, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10585, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100585, NULL),
(20001, 586, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10586, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100586, NULL),
(20001, 587, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10587, '5900A0971', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100587, NULL),
(20001, 588, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10588, '5900A1469', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100588, NULL),
(20001, 589, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10589, '5900A0885', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100589, NULL),
(20001, 590, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10590, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100590, NULL),
(20001, 591, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10591, '5900A1088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100591, NULL),
(20001, 592, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10592, '5900A1289', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100592, NULL),
(20001, 593, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10593, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100593, NULL),
(20001, 594, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10594, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100594, NULL),
(20001, 595, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10595, '5555A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100595, NULL),
(20001, 596, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10596, '5555A0070', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100596, NULL),
(20001, 597, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10597, '5485A0022', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100597, NULL),
(20001, 598, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10598, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100598, NULL),
(20001, 599, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10599, '0367A0101', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100599, NULL),
(20001, 600, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10600, '5508A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100600, NULL),
(20001, 601, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10601, '5508A0224', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100601, NULL),
(20001, 602, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10602, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100602, NULL),
(20001, 603, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10603, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100603, NULL),
(20001, 604, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10604, '5717A0555', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100604, NULL),
(20001, 605, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10605, '5717A0554', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100605, NULL),
(20001, 606, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10606, '5717A0526', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100606, NULL),
(20001, 607, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10607, '5262A0257/5262A0194/', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100607, NULL),
(20001, 608, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10608, '5552A0372', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100608, NULL),
(20001, 609, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10609, '5924A0134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100609, NULL),
(20001, 610, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10610, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100610, NULL),
(20001, 611, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10611, '5929A0013/5929A0014', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100611, NULL),
(20001, 612, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10612, '5650A0202', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100612, NULL),
(20001, 613, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10613, '5900A1282', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100613, NULL),
(20001, 614, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10614, '5900A1652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100614, NULL),
(20001, 615, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10615, '5508A0192/1043A0389', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100615, NULL),
(20001, 616, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10616, '5929A0027', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100616, NULL),
(20001, 617, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10617, '1156A0041/5495A0106', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100617, NULL),
(20001, 618, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10618, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100618, NULL),
(20001, 619, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10619, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100619, NULL),
(20001, 620, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10620, '1586A0393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100620, NULL),
(20001, 621, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10621, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100621, NULL),
(20001, 622, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10622, '0244A0497', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100622, NULL),
(20001, 623, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10623, '5607Y0038', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100623, NULL),
(20001, 624, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10624, '5607A0153', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100624, NULL),
(20001, 625, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10625, '5607A0477 /5890A0539', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100625, NULL),
(20001, 626, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10626, '5607A1484', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100626, NULL),
(20001, 627, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10627, '1304A0203/5620A1939', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100627, NULL),
(20001, 628, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10628, '5620A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100628, NULL),
(20001, 629, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10629, '5620A0869', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100629, NULL),
(20001, 630, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10630, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100630, NULL),
(20001, 631, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10631, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100631, NULL),
(20001, 632, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10632, '6098A0138', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100632, NULL),
(20001, 633, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10633, '5900A1285', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100633, NULL),
(20001, 634, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10634, '5625A0257', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100634, NULL),
(20001, 635, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10635, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100635, NULL),
(20001, 636, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10636, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100636, NULL),
(20001, 637, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10637, '5620A1687', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100637, NULL),
(20001, 638, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10638, '1304A0200/5620A0873', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100638, NULL),
(20001, 639, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10639, '5870A2846', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100639, NULL),
(20001, 640, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10640, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100640, NULL),
(20001, 641, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10641, '5512A0054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100641, NULL),
(20001, 642, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10642, '5717A0556', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100642, NULL),
(20001, 643, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10643, '5761A0089/5490A0214', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100643, NULL),
(20001, 644, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10644, '5490A0205', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100644, NULL),
(20001, 645, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10645, '5512A0059', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100645, NULL),
(20001, 646, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10646, '5924A0135', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100646, NULL),
(20001, 647, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10647, '5495A0160/0249A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100647, NULL),
(20001, 648, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10648, '6183A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100648, NULL),
(20001, 649, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10649, '5701A0091', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100649, NULL),
(20001, 650, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10650, '5701A0094', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100650, NULL),
(20001, 651, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10651, '5701A0008', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100651, NULL),
(20001, 652, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10652, '5701A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100652, NULL),
(20001, 653, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10653, '5701A0088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100653, NULL),
(20001, 654, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10654, '5701A0095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100654, NULL),
(20001, 655, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10655, '5701A0092', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100655, NULL),
(20001, 656, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10656, '5701A0096', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100656, NULL),
(20001, 657, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10657, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100657, NULL),
(20001, 658, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10658, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100658, NULL),
(20001, 659, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10659, '5657A0031', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100659, NULL),
(20001, 660, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10660, '0244A0962', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100660, NULL),
(20001, 661, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10661, '0244A0965', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100661, NULL),
(20001, 663, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10662, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100662, NULL),
(20001, 664, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10663, '5900A1449', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100663, NULL),
(20001, 665, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10664, '5900A1501', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100664, NULL),
(20001, 666, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10665, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100665, NULL),
(20001, 667, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10666, '0453A0123', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100666, NULL),
(20001, 668, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10667, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100667, NULL),
(20001, 669, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10668, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100668, NULL),
(20001, 670, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10669, '1156A0041/5495A010', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100669, NULL),
(20001, 671, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10670, '5497A0453', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100670, NULL),
(20001, 672, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10671, '0853A1693', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100671, NULL),
(20001, 673, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10672, '5890A0729', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100672, NULL),
(20001, 674, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10673, '5890A0674/5890A0455', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100673, NULL),
(20001, 675, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10674, '5890A1178', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100674, NULL),
(20001, 676, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10675, '5890A0510/5890A0756', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100675, NULL),
(20001, 677, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10676, '0256A2624', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100676, NULL),
(20001, 678, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10677, '5739A0071', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100677, NULL),
(20001, 679, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10678, '0244A1084', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100678, NULL),
(20001, 680, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10679, '5620A0948', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100679, NULL);
INSERT INTO `t_stock_process_line` (`spid`, `sl`, `dt`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `pqty`, `qty`, `nqty`, `act`, `toloc`, `tosloc`, `sts`, `skid`, `rem`) VALUES
(20001, 681, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10680, '5620A1054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100680, NULL),
(20001, 682, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10681, '5620A1053', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100681, NULL),
(20001, 683, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10682, '5620A2167', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100682, NULL),
(20001, 684, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10683, '5620A2393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100683, NULL),
(20001, 685, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10684, '0711A1034', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100684, NULL),
(20001, 686, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10685, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100685, NULL),
(20001, 687, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10686, '5900A1068', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100686, NULL),
(20001, 688, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10687, '5900A3223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100687, NULL),
(20001, 689, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10688, '5900Y0056', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100688, NULL),
(20001, 690, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10689, '5507A0016', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100689, NULL),
(20001, 691, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10690, '5900A1665', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100690, NULL),
(20001, 692, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10691, '5507A0020', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100691, NULL),
(20001, 693, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10692, '5542A1531', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100692, NULL),
(20001, 694, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10693, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100693, NULL),
(20001, 695, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10694, '5900A2625', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100694, NULL),
(20001, 696, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10695, '5552A0315', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100695, NULL),
(20001, 697, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10696, '5620A0949', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100696, NULL),
(20001, 698, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10697, '5620A2334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100697, NULL),
(20001, 699, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10698, '5620A1051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100698, NULL),
(20001, 700, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10699, '5620A0166', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100699, NULL),
(20001, 701, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10700, '5620A1046', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100700, NULL),
(20001, 702, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10701, '5620A1052', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100701, NULL),
(20001, 703, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10702, '5620A1045', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100702, NULL),
(20001, 704, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10703, '5620A1043', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100703, NULL),
(20001, 705, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10704, '5620A2400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100704, NULL),
(20001, 706, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10705, '5552A0334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100705, NULL),
(20001, 707, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10706, '5669A0006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100706, NULL),
(20001, 708, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10707, '5669A0400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100707, NULL),
(20001, 709, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10708, '5669A0414', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100708, NULL),
(20001, 710, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10709, '5669A0397', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100709, NULL),
(20001, 711, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10710, '5669A0100', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100710, NULL),
(20001, 712, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10711, '5669A0411', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100711, NULL),
(20001, 713, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10712, '5669A0009', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100712, NULL),
(20001, 714, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10713, '5669A0984', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100713, NULL),
(20001, 715, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10714, '1629A0055', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100714, NULL),
(20001, 716, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10715, '0546A4280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100715, NULL),
(20001, 717, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10716, '1430A0273', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100716, NULL),
(20001, 718, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10717, '0961A0250', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100717, NULL),
(20001, 719, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10718, '5625A0269', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100718, NULL),
(20001, 720, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10719, '0545A0308', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100719, NULL),
(20001, 721, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10720, '5900A1485', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100720, NULL),
(20001, 722, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10721, '5924A0681', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100721, NULL),
(20001, 723, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10722, '5900A1176', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100722, NULL),
(20001, 724, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10723, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100723, NULL),
(20001, 725, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10724, '0244A0829', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100724, NULL),
(20001, 726, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10725, '5900A1364', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100725, NULL),
(20001, 727, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10726, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100726, NULL),
(20001, 728, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10727, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100727, NULL),
(20001, 729, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10728, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100728, NULL),
(20001, 730, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10729, '5900A1195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100729, NULL),
(20001, 731, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10730, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100730, NULL),
(20001, 732, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10731, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100731, NULL),
(20001, 733, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10732, '5900A1098', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100732, NULL),
(20001, 734, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10733, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100733, NULL),
(20001, 735, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10734, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100734, NULL),
(20001, 736, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10735, '5900A1093', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100735, NULL),
(20001, 737, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10736, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100736, NULL),
(20001, 738, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10737, '5900A1342', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100737, NULL),
(20001, 739, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10738, '5900A1147', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100738, NULL),
(20001, 740, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10739, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100739, NULL),
(20001, 741, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10740, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100740, NULL),
(20001, 742, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10741, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100741, NULL),
(20001, 743, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10742, '5648A0155', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100742, NULL),
(20001, 744, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10743, '5510A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100743, NULL),
(20001, 745, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10744, '1041A2940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100744, NULL),
(20001, 746, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10745, '1047A1795', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100745, NULL),
(20001, 747, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10746, '5542A0907', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100746, NULL),
(20001, 748, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10747, '5581A0003', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100747, NULL),
(20001, 749, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10748, '0380A0622', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100748, NULL),
(20001, 750, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10749, '5542A1509', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100749, NULL),
(20001, 751, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10750, '5542A0280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100750, NULL),
(20001, 752, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10751, '5620A1095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100751, NULL),
(20001, 753, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10752, '5542A0940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100752, NULL),
(20001, 754, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10753, '5542A0753', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100753, NULL),
(20001, 755, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10754, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100754, NULL),
(20001, 756, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10755, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100755, NULL),
(20001, 757, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10756, '0255A0639', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100756, NULL),
(20001, 758, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10757, '5900A1519', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100757, NULL),
(20001, 759, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10758, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100758, NULL),
(20001, 760, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10759, '5900A1134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100759, NULL),
(20001, 761, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10760, '5900A1395', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100760, NULL),
(20001, 762, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10761, '5900Y0019', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100761, NULL),
(20001, 763, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10762, '5900A2601', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100762, NULL),
(20001, 764, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10763, '5900Y0402', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100763, NULL),
(20001, 765, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10764, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100764, NULL),
(20001, 766, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10765, '5521A0404', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100765, NULL),
(20001, 767, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10766, '5900A1978', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100766, NULL),
(20001, 768, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10767, '5894A0713', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100767, NULL),
(20001, 769, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10768, '1586A0663', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100768, NULL),
(20001, 770, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10769, '5542A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100769, NULL),
(20001, 771, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10770, '1041A2427', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100770, NULL),
(20001, 772, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10771, '5542A1503', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100771, NULL),
(20001, 773, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10772, '1586A0648', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100772, NULL),
(20001, 774, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10773, '1586A0652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100773, NULL),
(20001, 775, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10774, '5900A1451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100774, NULL),
(20001, 776, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10775, '5625A0113', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100775, NULL),
(20001, 777, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10776, '5648A0121', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100776, NULL),
(20001, 778, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10777, '1043A0155', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100777, NULL),
(20001, 779, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10778, '5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100778, NULL),
(20001, 780, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10779, '3274A0019/5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100779, NULL),
(20001, 781, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10780, '5968A0102', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100780, NULL),
(20001, 782, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10781, '5778A3492', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100781, NULL),
(20001, 783, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10782, '1329A0139', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100782, NULL),
(20001, 784, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10783, '5900A0965', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100783, NULL),
(20001, 785, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10784, '5900A0913', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100784, NULL),
(20001, 786, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10785, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100785, NULL),
(20001, 787, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10786, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100786, NULL),
(20001, 788, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10787, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100787, NULL),
(20001, 789, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10788, '5900A2786', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100788, NULL),
(20001, 790, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10789, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100789, NULL),
(20001, 791, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10790, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100790, NULL),
(20001, 792, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10791, '5872A2035 ', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100791, NULL),
(20001, 793, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10792, '5885A0326', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100792, NULL),
(20001, 794, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10793, '5924A0102', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100793, NULL),
(20001, 795, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10794, '5557A0037', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100794, NULL),
(20001, 796, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10795, '5924A0074', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100795, NULL),
(20001, 797, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10796, '5924A0116', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100796, NULL),
(20001, 798, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10797, '5929A0008', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100797, NULL),
(20001, 799, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10798, '6045A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100798, NULL),
(20001, 800, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10799, '5956A0521', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100799, NULL),
(20001, 801, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10800, '5929A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100800, NULL),
(20001, 802, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10801, '6098A0167/5625A0327', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100801, NULL),
(20001, 803, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10802, '5900A1091', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100802, NULL),
(20001, 804, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10803, '5924A0081', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100803, NULL),
(20001, 805, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10804, '5924A0083', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100804, NULL),
(20001, 806, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10805, '5924A0082', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100805, NULL),
(20001, 807, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10806, '5924A0102', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100806, NULL),
(20001, 808, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10807, '5540A1233 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100807, NULL),
(20001, 809, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10808, '5620A1877 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100808, NULL),
(20001, 810, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10809, '6045A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100809, NULL),
(20001, 811, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10810, '6045A0002', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100810, NULL),
(20001, 812, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10811, '5956A0522', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100811, NULL),
(20001, 813, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10812, '6045A0001', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100812, NULL),
(20001, 814, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10813, '6045A0002', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100813, NULL),
(20001, 815, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10814, '5717A0690', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100814, NULL),
(20001, 816, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10815, '5717A0518', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100815, NULL),
(20001, 817, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10816, '5717A0517', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100816, NULL),
(20001, 818, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10817, '6045A0172', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100817, NULL),
(20001, 819, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10818, '5717A0699', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100818, NULL),
(20001, 820, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10819, '6045A0136', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100819, NULL),
(20001, 821, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10820, '6045A0146', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100820, NULL),
(20001, 822, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10821, '6045A0143', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100821, NULL),
(20001, 823, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10822, '5924A0173', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100822, NULL),
(20001, 824, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10823, '5924A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100823, NULL),
(20001, 825, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10824, '5924A0171', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100824, NULL),
(20001, 826, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10825, '5613A0187', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100825, NULL),
(20001, 827, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10826, '5613A0186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100826, NULL),
(20001, 828, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10827, '5924A0164', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100827, NULL),
(20001, 829, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10828, '5613A0245', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100828, NULL),
(20001, 830, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10829, '5929A0009', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100829, NULL),
(20001, 831, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10830, '5625A0325', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100830, NULL),
(20001, 832, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10831, '5924A0118', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100831, NULL),
(20001, 833, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10832, '5924A0142', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100832, NULL),
(20001, 834, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10833, '5523A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100833, NULL),
(20001, 835, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10834, '5924A0119', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100834, NULL),
(20001, 836, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10835, '5508A0140', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100835, NULL),
(20001, 837, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10836, '5872A2035', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100836, NULL),
(20001, 838, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10837, '5924A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100837, NULL),
(20001, 839, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10838, '5045A0008', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100838, NULL),
(20001, 840, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10839, '5924A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100839, NULL),
(20001, 841, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10840, '5700A0852', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100840, NULL),
(20001, 842, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10841, '5620A2284', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100841, NULL),
(20001, 843, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10842, '5508A0269', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100842, NULL),
(20001, 844, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10843, '5540A1431', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100843, NULL),
(20001, 845, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10844, '5540A1432', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100844, NULL),
(20001, 846, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10845, '5540A1370', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100845, NULL),
(20001, 847, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10846, '5540A1368', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100846, NULL),
(20001, 848, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10847, '5540A1233', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100847, NULL),
(20001, 849, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10848, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100848, NULL),
(20001, 850, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10849, '5542A0932', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100849, NULL),
(20001, 851, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10850, '5620A0409', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100850, NULL),
(20001, 852, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10851, '5542A1218', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100851, NULL),
(20001, 853, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10852, '5557A0037', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100852, NULL),
(20001, 854, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10853, '5700A0853', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100853, NULL),
(20001, 855, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10854, '5700A0869', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100854, NULL),
(20001, 856, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10855, '5700A0870', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100855, NULL),
(20001, 857, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10856, '5700A0871', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100856, NULL),
(20001, 858, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10857, '6045A0145', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100857, NULL),
(20001, 859, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10858, '5508A0249', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100858, NULL),
(20001, 860, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10859, '5700A0854', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100859, NULL),
(20001, 861, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10860, '5924A0317', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100860, NULL),
(20001, 862, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10861, '5872A2197', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100861, NULL),
(20001, 863, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10862, '5924A0316', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100862, NULL),
(20001, 864, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10863, '5924A0318', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100863, NULL),
(20001, 865, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10864, '5540A1370', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100864, NULL),
(20001, 866, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10865, '5540A1368', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100865, NULL),
(20001, 867, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10866, '5924A0283', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100866, NULL),
(20001, 868, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10867, '5900A1208', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100867, NULL),
(20001, 869, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10868, '5885A0289', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100868, NULL),
(20001, 870, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10869, '5613A0187', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100869, NULL),
(20001, 871, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10870, '5613A0186', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100870, NULL),
(20001, 872, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10871, '6098A0168', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100871, NULL),
(20001, 873, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10872, '5929A0003', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100872, NULL),
(20001, 874, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10873, '5924A0077', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100873, NULL),
(20001, 875, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10874, '5507A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100874, NULL),
(20001, 876, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10875, '5507A0036', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100875, NULL),
(20001, 877, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10876, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100876, NULL),
(20001, 878, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10877, '5924A0123', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100877, NULL),
(20001, 879, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10878, '5625A0430', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100878, NULL),
(20001, 880, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10879, '5900A1968', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100879, NULL),
(20001, 881, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10880, '5520A0435', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100880, NULL),
(20001, 882, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10881, '5495A0123', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100881, NULL),
(20001, 883, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10882, '5872A2035 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100882, NULL),
(20001, 884, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10883, '6183A0015', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100883, NULL),
(20001, 885, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10884, '5964A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100884, NULL),
(20001, 886, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10885, '0958A1983', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100885, NULL),
(20001, 887, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10886, '5540A1431', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100886, NULL),
(20001, 888, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10887, '5700A0882', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100887, NULL),
(20001, 889, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10888, '5717A0518', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100888, NULL),
(20001, 890, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10889, '6045A0189', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100889, NULL),
(20001, 891, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10890, '5717A0699', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100890, NULL),
(20001, 892, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10891, '6098A0125', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100891, NULL),
(20001, 893, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10892, '5717A0517', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100892, NULL),
(20001, 894, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10893, '5717A0690', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100893, NULL),
(20001, 895, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10894, '5542A0014', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100894, NULL),
(20001, 896, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10895, '6045A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100895, NULL),
(20001, 897, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10896, '5090A0029', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100896, NULL),
(20001, 898, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10897, '5717A0699', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100897, NULL),
(20001, 899, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10898, '6045A0172', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100898, NULL),
(20001, 900, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10899, '5717A0517', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100899, NULL),
(20001, 901, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10900, '5717A0690', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100900, NULL),
(20001, 902, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10901, '5557A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100901, NULL),
(20001, 903, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10902, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100902, NULL);
INSERT INTO `t_stock_process_line` (`spid`, `sl`, `dt`, `bprocess`, `process`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `pqty`, `qty`, `nqty`, `act`, `toloc`, `tosloc`, `sts`, `skid`, `rem`) VALUES
(20001, 904, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10903, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100903, NULL),
(20001, 905, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10904, '5924A0074', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100904, NULL),
(20001, 906, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10905, '5900A2021', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100905, NULL),
(20001, 907, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10906, '5900A2026', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100906, NULL),
(20001, 908, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10907, '5900A1229', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100907, NULL),
(20001, 909, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10908, '5924A0081', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100908, NULL),
(20001, 910, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10909, '5924A0083', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100909, NULL),
(20001, 911, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10910, '5924A0102', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100910, NULL),
(20001, 912, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10911, '5924A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100911, NULL),
(20001, 913, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10912, '5924A0079', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100912, NULL),
(20001, 914, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10913, '5929A0003', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100913, NULL),
(20001, 915, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10914, '5924A0111', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100914, NULL),
(20001, 916, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10915, '5929A0012', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100915, NULL),
(20001, 917, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10916, '5924A0125', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100916, NULL),
(20001, 918, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10917, '5924A0213', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100917, NULL),
(20001, 919, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10918, '5924A0216', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100918, NULL),
(20001, 920, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10919, '5924A0215', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100919, NULL),
(20001, 921, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10920, '5924A0077', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100920, NULL),
(20001, 922, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10921, '5929A0004', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100921, NULL),
(20001, 923, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10922, '5924A0074', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100922, NULL),
(20001, 924, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10923, '5900A1091', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100923, NULL),
(20001, 925, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10924, '0958A1983', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100924, NULL),
(20001, 926, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10925, '5495A0205', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100925, NULL),
(20001, 927, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10926, '5508A0319', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100926, NULL),
(20001, 928, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10927, '5520A0434', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100927, NULL),
(20001, 929, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10928, '5924A0636', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100928, NULL),
(20001, 930, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10929, '5956A0990', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100929, NULL),
(20001, 931, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10930, '5872A2054', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100930, NULL),
(20001, 932, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10931, '5273A0273', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100931, NULL),
(20001, 933, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10932, '5964A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100932, NULL),
(20001, 934, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10933, '5613A0359', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100933, NULL),
(20001, 935, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10934, '5625A0326', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100934, NULL),
(20001, 936, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10935, '5700A0854', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100935, NULL),
(20001, 937, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10936, '5607A0666', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100936, NULL),
(20001, 938, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10937, '5620A1667', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100937, NULL),
(20001, 939, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10938, '5620A1768', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100938, NULL),
(20001, 940, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10939, '5620A1787', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100939, NULL),
(20001, 941, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10940, '5620A2521', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100940, NULL),
(20001, 942, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10941, '5620A1788', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100941, NULL),
(20001, 943, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10942, '5620A1773', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100942, NULL),
(20001, 944, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10943, '5620A1314', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100943, NULL),
(20001, 945, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10944, '5620A2566', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100944, NULL),
(20001, 946, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10945, '5956A0522', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100945, NULL),
(20001, 947, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10946, '5885A0289', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100946, NULL),
(20001, 948, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10947, '5613A0186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100947, NULL),
(20001, 949, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10948, '5613A0187', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100948, NULL),
(20001, 950, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10949, '5700A0812', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100949, NULL),
(20001, 951, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10950, '5700A0854', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100950, NULL),
(20001, 952, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10951, '5700A0881', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100951, NULL),
(20001, 953, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10952, '5700A0882', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100952, NULL),
(20001, 954, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10953, '5700A0885', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100953, NULL),
(20001, 955, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10954, '6045A0189', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100954, NULL),
(20001, 956, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10955, '5956A0990', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100955, NULL),
(20001, 957, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10956, '6045A0191', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100956, NULL),
(20001, 958, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10957, '5872A2054', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100957, NULL),
(20001, 959, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10958, '1043A0439', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100958, NULL),
(20001, 960, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10959, '5580A1885', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100959, NULL),
(20001, 961, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10960, '5964A0142', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100960, NULL),
(20001, 962, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10961, '5620A1686', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100961, NULL),
(20001, 963, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10962, '5620A0362', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100962, NULL),
(20001, 964, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10963, '5620A1753', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100963, NULL),
(20001, 965, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10964, '5620A0463', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100964, NULL),
(20001, 966, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10965, '5620A0491', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100965, NULL),
(20001, 967, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10966, '5620A0436', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100966, NULL),
(20001, 968, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10967, '5918A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100967, NULL),
(20001, 969, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10968, '5900A3800', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100968, NULL),
(20001, 970, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10969, '5700A0017', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100969, NULL),
(20001, 971, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10970, '5620A0250', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100970, NULL),
(20001, 972, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10971, '5620A0497', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100971, NULL),
(20001, 973, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10972, '5620A1183', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100972, NULL),
(20001, 974, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10973, '5620A2117', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100973, NULL),
(20001, 975, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10974, '5620A1468', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100974, NULL),
(20001, 976, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10975, '5620A0436', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100975, NULL),
(20001, 977, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10976, '5620A0986', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100976, NULL),
(20001, 978, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10977, '5620A1763', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100977, NULL),
(20001, 979, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10978, '5620A0250', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100978, NULL),
(20001, 980, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10979, '5620A0890', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100979, NULL),
(20001, 981, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10980, '5620A2019 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100980, NULL),
(20001, 982, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10981, '5620A0532', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100981, NULL),
(20001, 983, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10982, '5620A0873', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100982, NULL),
(20001, 984, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10983, '5620A0987', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100983, NULL),
(20001, 985, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10984, '5669A0018', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100984, NULL),
(20001, 986, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10985, '5669A0396', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100985, NULL),
(20001, 987, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10986, '5669A0417', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100986, NULL),
(20001, 988, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10987, '5669A0985', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100987, NULL),
(20001, 989, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10988, '5669A0201', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100988, NULL),
(20001, 990, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10989, '5669A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100989, NULL),
(20001, 991, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10990, '5262A0199', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100990, NULL),
(20001, 992, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10991, '5540A0382', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100991, NULL),
(20001, 993, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10992, '5620A2214', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100992, NULL),
(20001, 994, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10993, '5620A1644', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100993, NULL),
(20001, 995, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10994, '5620A2019', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100994, NULL),
(20001, 996, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10995, '5620A2086', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100995, NULL),
(20001, 997, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10996, '5620A1945', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100996, NULL),
(20001, 998, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10997, '5620A1937', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100997, NULL),
(20001, 999, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10998, '5620A2210', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100998, NULL),
(20001, 1000, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 10999, '5623A1186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 100999, NULL),
(20001, 1001, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11000, '5620A2042', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101000, NULL),
(20001, 1002, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11001, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101001, NULL),
(20001, 1003, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11002, '6098A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101002, NULL),
(20001, 1004, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11003, '6183A0050', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101003, NULL),
(20001, 1005, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11004, '5540A1233', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101004, NULL),
(20001, 1006, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11005, '0517A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101005, NULL),
(20001, 1007, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11006, '0517A0422', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101006, NULL),
(20001, 1008, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11007, '5700A0885', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101007, NULL),
(20001, 1009, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11008, '5508A0942', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101008, NULL),
(20001, 1010, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11009, '5580A0941', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101009, NULL),
(20001, 1011, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11010, '6098A0533', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101010, NULL),
(20001, 1012, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11011, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101011, NULL),
(20001, 1013, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11012, '5620A1818', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101012, NULL),
(20001, 1014, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11013, '5620A0898', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101013, NULL),
(20001, 1015, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11014, '5620A0429', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101014, NULL),
(20001, 1016, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11015, '5620A2571', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101015, NULL),
(20001, 1017, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11016, '5620A1754', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101016, NULL),
(20001, 1018, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11017, '5620A1466', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'm', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101017, NULL),
(20001, 1019, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11018, '5584A0031', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101018, NULL),
(20001, 1020, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11019, '5384A0013', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101019, NULL),
(20001, 1021, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11020, '5623A1186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101020, NULL),
(20001, 1022, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11021, '5607A0190', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101021, NULL),
(20001, 1023, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11022, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101022, NULL),
(20001, 1024, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11023, '0485A0740', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101023, NULL),
(20001, 1025, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11024, '5542A1911/ 5620A2393', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101024, NULL),
(20001, 1026, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11025, '5620A2351', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101025, NULL),
(20001, 1027, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11026, '5620A1045', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101026, NULL),
(20001, 1028, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11027, '5620A2334', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101027, NULL),
(20001, 1029, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11028, '5620A1927', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101028, NULL),
(20001, 1030, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11029, '5620A2426', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101029, NULL),
(20001, 1031, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11030, '5620A1821', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101030, NULL),
(20001, 1032, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11031, '5620A2879', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101031, NULL),
(20001, 1033, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11032, '5900A2794', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101032, NULL),
(20001, 1034, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11033, '5900A2001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101033, NULL),
(20001, 1035, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11034, '5900A3910', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101034, NULL),
(20001, 1036, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11035, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101035, NULL),
(20001, 1037, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11036, '5900A2832', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101036, NULL),
(20001, 1038, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11037, '5900A1922', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101037, NULL),
(20001, 1039, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11038, '5900A2125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101038, NULL),
(20001, 1040, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11039, '5900A2145', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101039, NULL),
(20001, 1041, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11040, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101040, NULL),
(20001, 1042, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11041, '5900A3995', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101041, NULL),
(20001, 1043, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11042, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101042, NULL),
(20001, 1044, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11043, '5900A1322', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101043, NULL),
(20001, 1045, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11044, '5900A2103', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101044, NULL),
(20001, 1046, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11045, '5900A2059', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101045, NULL),
(20001, 1047, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11046, '5507A0103', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101046, NULL),
(20001, 1048, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11047, '5507A0104', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101047, NULL),
(20001, 1049, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11048, '5885A0036', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101048, NULL),
(20001, 1050, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11049, '5047A0088', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101049, NULL),
(20001, 1051, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11050, '5872A2035 ', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101050, NULL),
(20001, 1052, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11051, '5607A0699', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101051, NULL),
(20001, 1053, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11052, '5900A4017', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101052, NULL),
(20001, 1054, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11053, '5956A3994', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101053, NULL),
(20001, 1055, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11054, '5540A1811', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101054, NULL),
(20001, 1056, '2024-02-29 00:00:00', 'StockAdjustmentExcel', 'SAE', 11055, '5956A4131', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '', '', 'Released', 101055, NULL),
(20002, 1, '2024-03-28 00:00:00', 'StockIN', 'SI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 33, NULL, NULL, NULL, NULL, 'Released', 100003, NULL),
(20003, 1, '2024-04-13 00:00:00', 'StockIN', 'SI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 20, NULL, NULL, NULL, NULL, 'Released', 100002, NULL),
(20004, 1, '2024-04-13 00:00:00', 'StockOUT', 'SO', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 20, 10, 10, NULL, NULL, NULL, 'Released', 100002, NULL),
(20005, 1, '2024-04-13 00:00:00', 'StockOUT', 'SO', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 33, 5, 28, NULL, NULL, NULL, 'Released', 100003, NULL),
(20006, 1, '2024-04-13 10:05:41', 'StockAdjustment', 'SA', 11056, '', 'TEST MATERIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101056, NULL),
(20007, 1, '2024-04-13 10:06:29', 'StockAdjustment', 'SA', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101057, NULL),
(20008, 1, '2024-04-11 00:00:00', 'StockIN', 'SI', 11056, '', 'TEST MATERIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, NULL, NULL, 'Released', 101056, NULL),
(20009, 1, '2024-04-13 00:00:00', 'StockIN', 'SI', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, NULL, NULL, 'Released', 101057, NULL),
(20010, 1, '2024-04-12 00:00:00', 'StockOUT', 'SO', 11056, '', 'TEST MATERIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 5, 2, 3, NULL, NULL, NULL, 'Released', 101056, NULL),
(20011, 1, '2024-04-13 00:00:00', 'StockTransfer', 'ST', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', 10, 2, 8, NULL, 'Vessel', NULL, 'Released', 101057, NULL),
(20012, 1, '2024-04-13 00:00:00', 'InternalMovement', 'IM', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', 8, 3, 5, NULL, NULL, 'TEST SUB LOC:RACK TEST:3', 'Released', 101057, NULL),
(20013, 1, '2024-04-13 00:00:00', 'StockOUT', 'SO', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', 'TEST SUB LOC', 'RACK TEST', 3, 1, 2, NULL, NULL, NULL, 'Released', 101059, NULL),
(20014, 1, '2024-04-13 00:00:00', 'StockSCRAP', 'SCP', 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, NULL, '', 'Released', 101057, NULL),
(20015, 1, '2024-04-13 00:00:00', 'StockAdjustment', 'SA', 11056, '', 'TEST MATERIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 3, 6, 6, 3, NULL, NULL, 'Released', 101056, 'adjust for MAR-2024 Stock Adjust Process'),
(20016, 1, '2024-04-11 00:00:00', 'StockINExcel', 'SIE', 11058, '', 'COMPUTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 101060, NULL),
(20016, 2, '2024-04-12 00:00:00', 'StockINExcel', 'SIE', 11059, '', 'KEYBOARD', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 3, NULL, NULL, '', '', 'Released', 101061, NULL),
(20016, 3, '2024-04-13 00:00:00', 'StockINExcel', 'SIE', 11060, '', 'MOUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 101062, NULL),
(20018, 1, '2024-04-13 00:00:00', 'StockAdjustmentExcel', 'SAE', 11058, '', 'COMPUTER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 15, NULL, NULL, '', '', 'Released', 101060, NULL),
(20018, 2, '2024-04-13 00:00:00', 'StockAdjustmentExcel', 'SAE', 11060, '', 'MOUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 20, NULL, NULL, '', '', 'Released', 101062, NULL),
(20019, 1, '2024-04-13 10:46:30', 'StockAdjustment', 'SA', 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101063, NULL),
(20020, 1, '2024-04-13 00:00:00', 'StockIN', 'SI', 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 6, NULL, NULL, NULL, NULL, 'Released', 101063, NULL),
(20021, 1, '2024-04-13 00:00:00', 'StockIN', 'SI', 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, NULL, NULL, 'Released', 101063, NULL),
(20022, 1, '2024-04-13 00:00:00', 'StockOUT', 'SO', 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 16, 8, 8, NULL, NULL, NULL, 'Released', 101063, NULL),
(20023, 1, '2024-04-13 00:00:00', 'StockOUT', 'SO', 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 8, 5, 3, NULL, NULL, NULL, 'Released', 101063, NULL),
(20024, 1, '2024-05-03 15:26:12', 'StockAdjustment', 'SA', 11062, '9090A1010', 'TEST MATRIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101064, NULL),
(20025, 1, '2024-05-03 00:00:00', 'InternalMovement', 'IM', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 10, 5, 5, NULL, NULL, 'CABLE YARD:R1-A:2,OUTSIDE STORE:R1-B:3', 'Released', 100002, NULL),
(20034, 1, '2024-10-10 00:00:00', 'StockIN', 'SI', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', NULL, 33, NULL, NULL, NULL, NULL, 'New', 100002, NULL),
(20035, 1, '2024-07-08 16:52:26', 'StockAdjustment', 'SA', 11063, '1212A9090', 'BOILER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101067, NULL),
(20036, 1, '2024-10-10 00:00:00', 'StockIN', 'SI', 11063, '1212A9090', 'BOILER', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 34, NULL, NULL, NULL, NULL, 'Released', 101067, NULL),
(20037, 1, '2024-07-13 00:00:00', 'StockIN', 'SI', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 99, NULL, NULL, NULL, NULL, 'Released', 100003, NULL),
(20038, 1, '2024-07-13 00:00:00', 'StockOUT', 'SO', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', '', 'NOS', 'N', 'Toolkit Store', '', '', 29, 12, 17, NULL, NULL, NULL, 'Released', 100017, NULL),
(20039, 1, '2024-07-13 00:00:00', 'StockOUT', 'SO', 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', '', 'NOS', 'N', 'Toolkit Store', '', '', 17, 2, 15, NULL, NULL, NULL, 'Released', 100017, NULL),
(20040, 1, '2024-07-13 00:00:00', 'StockOUT', 'SO', 10011, '0093A0119', 'CABLE GLAND  19 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 266, 2, 264, NULL, NULL, NULL, 'Released', 100011, NULL),
(20041, 1, '2024-07-13 00:00:00', 'StockOUT', 'SO', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 127, 2, 125, NULL, NULL, NULL, 'Released', 100003, NULL),
(20042, 1, '2024-07-13 00:00:00', 'StockTransfer', 'ST', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 125, 2, 123, NULL, 'Caster', NULL, 'Released', 100003, NULL),
(20043, 1, '2024-07-13 00:00:00', 'StockTransfer', 'ST', 10011, '0093A0119', 'CABLE GLAND  19 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 264, 6, 258, NULL, 'SMLP', NULL, 'Released', 100011, NULL),
(20044, 1, '2024-07-13 00:00:00', 'InternalMovement', 'IM', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 5, 2, 3, NULL, NULL, '9MTR STORE:RACK 1:2', 'Released', 100002, NULL),
(20045, 1, '2024-07-13 00:00:00', 'StockSCRAP', 'SCP', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 123, 2, 121, NULL, NULL, NULL, 'Released', 100003, NULL),
(20046, 1, '2024-07-13 00:00:00', 'StockSCRAP', 'SCP', 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 121, 3, 118, NULL, NULL, NULL, 'Released', 100003, NULL),
(20047, 1, '2024-07-13 00:00:00', 'StockAdjustment', 'SA', 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 3, 10, 10, 7, NULL, NULL, 'Released', 100002, 'india'),
(20053, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11064, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '2', '', 'Released', 101071, NULL),
(20053, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11065, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, '5', '', 'Released', 101072, NULL),
(20054, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11066, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 101073, NULL),
(20054, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11067, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 101074, NULL),
(20055, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11068, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 101075, NULL),
(20055, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11069, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 101076, NULL),
(20056, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11068, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 2, NULL, NULL, '', '', 'Released', 101075, NULL),
(20056, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11069, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 5, NULL, NULL, '', '', 'Released', 101076, NULL),
(20057, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 101077, NULL),
(20057, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 15, NULL, NULL, '', '', 'Released', 101078, NULL),
(20058, 1, '2024-07-14 00:00:00', 'StockAdjustment', 'SA', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 101077, NULL),
(20058, 2, '2024-07-14 00:00:00', 'StockAdjustment', 'SA', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 15, NULL, NULL, '', '', 'Released', 101078, NULL),
(20059, 1, '2024-07-14 00:00:00', 'StockIN', 'SI', 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 10, NULL, NULL, '', '', 'Released', 101077, NULL),
(20059, 2, '2024-07-14 00:00:00', 'StockIN', 'SI', 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 15, NULL, NULL, '', '', 'Released', 101078, NULL),
(20060, 1, '2024-07-16 14:28:14', 'StockAdjustment', 'SA', 11072, '1001E9090', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101079, NULL),
(20061, 1, '2024-07-16 14:29:18', 'StockAdjustment', 'SA', 11073, '2020R2001', 'BONGO', '', 'NOS', 'N', 'Toolkit Store', '', '', NULL, 0, NULL, NULL, NULL, NULL, 'Released', 101080, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_rack`
--

CREATE TABLE `t_stock_rack` (
  `id` int(11) NOT NULL,
  `rack` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_reorder`
--

CREATE TABLE `t_stock_reorder` (
  `sl` int(11) NOT NULL,
  `itid` int(11) DEFAULT NULL,
  `mtcd` varchar(10) DEFAULT NULL,
  `material` varchar(200) DEFAULT NULL,
  `wlvl` int(11) DEFAULT NULL,
  `rlvl` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_room`
--

CREATE TABLE `t_stock_room` (
  `id` int(11) NOT NULL,
  `room` varchar(40) DEFAULT NULL,
  `sts` varchar(15) DEFAULT NULL,
  `cbid` int(11) DEFAULT NULL,
  `cby` varchar(50) DEFAULT NULL,
  `cdt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock_sap`
--

CREATE TABLE `t_stock_sap` (
  `sl` int(11) NOT NULL,
  `plant` varchar(50) DEFAULT NULL,
  `mtcd` varchar(10) DEFAULT NULL,
  `material` varchar(100) DEFAULT NULL,
  `stloc` varchar(50) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `udt` date DEFAULT NULL,
  `uby` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_stock_sap`
--

INSERT INTO `t_stock_sap` (`sl`, `plant`, `mtcd`, `material`, `stloc`, `qty`, `unit`, `udt`, `uby`) VALUES
(2, '025  LD-1 Plant', '6028A0524', 'PWR DSTBN PNL;ELECTRODE ARM ASMBLY PHASE', '025 L190                       Vessel Elect str', 1, 'NOS', '2023-03-31', NULL),
(3, '025  LD-1 Plant', '6028A0525', 'PWR DSTBN PNL;ELECTRODE ARM ASMBLY PHASE', '025 L190                       Vessel Elect str', 1, 'NOS', '2023-03-31', NULL),
(4, '025  LD-1 Plant', '6028A0297', 'PWR DSTBN PNL;ELECTRODE ARM ASSEMBLY CU', '025 L190                       Vessel Elect str', 1, 'NOS', '2023-03-31', NULL),
(5, '025  LD-1 Plant', '5581A0003', 'THYRISTOR,IGCT,50MA,4500V,RACK,DISC,HL00', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(6, '025  LD-1 Plant', '6028A0062', 'POWER DISTRIBUTION ACCESSORIES', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(7, '025  LD-1 Plant', '5964A0082', 'PNL;PLC BASED ELECT. CONTROL PANEL ,THRE', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(8, '025  LD-1 Plant', '5924A0250', 'SPL MOTR;STALL TORQUE SLIP RING MOTOR ,B', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(9, '025  LD-1 Plant', '5626A0436', 'OLTC COMPLETE ASSEMBLY LF1 ,EASUN MR ,AL', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(10, '025  LD-1 Plant', '5587A0009', 'CRD;MONOSPIRAL,4CX70MM2,100 METER', '025 L1EW                       Electrical Wards', 1, 'SET', '2023-03-31', NULL),
(11, '025  LD-1 Plant', '5620A4241', 'LVDT POSITION SENSOR ,SENSORE ,690100050', '025 L1EW                       Electrical Wards', 6, 'PCE', '2023-03-31', NULL),
(12, '025  LD-1 Plant', '5580A0942', 'COUPLING;COUPLING WITH BRAKE DRUM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(13, '025  LD-1 Plant', '5669A1629', '27BT 65:1 GEAR/ACCES. KIT ,OTIS ,LIFT ,O', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(14, '025  LD-1 Plant', '5512A0207', 'TUNDISH LOAD CELL ,BLH NOBEL ,DSA R 50T', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(15, '025  LD-1 Plant', '5924A0135', 'SPL MOTR;CRD TORQUE MOTOR,DEMAG', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(16, '025  LD-1 Plant', '6028A0061', 'POWER DISTRIBUTION ACCESSORIES', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(17, '025  LD-1 Plant', '5929A0011', 'BRAK MTR;CRD MOTOR WITH COUPLING,19.6NM', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(18, '025  LD-1 Plant', '5490A0205', 'WEGHNG M/C ACC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(19, '025  LD-1 Plant', '5929A0046', 'BRAK MOTR;CARRIAGE MOTOR ,1.1 KW,SMS CON', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(20, '025  LD-1 Plant', '5669A1635', '27 BT 65:1 WORM SHAFT ASSY ,OTIS ,LIFT ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(21, '025  LD-1 Plant', '5929A0002', 'BRAK MTR;VFD MOTOR,4KW,WEG,10003405635', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(22, '025  LD-1 Plant', '5924A0283', 'SPL MOTR;CC1 WSU BOTTOM ROLL MOTOR ,WEG', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(23, '025  LD-1 Plant', '5924A0118', 'SPL MOTR;WITHDRAWL MOTOR,SIEMENS VAI', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(24, '025  LD-1 Plant', '5894A0713', 'GEARBOX;HELICAL ,26.44:1 ,NO SPECIAL FEA', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(25, '025  LD-1 Plant', '5885A0333', 'PROXMTY;INDUCTIVE,20MM,10-30V,IP67', '025 LDE2                       LD1 DSI elect', 28, 'NOS', '2023-03-31', NULL),
(26, '025  LD-1 Plant', '5700A0017', 'FIELD SNSR,LB-452 CAST EXPERT,BERTHOLD T', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(27, '025  LD-1 Plant', '5540A1233', 'ELTNC CARD;HYDRAULIC', '025 L1EW                       Electrical Wards', 18, 'NOS', '2023-03-31', NULL),
(28, '025  LD-1 Plant', '0936A0423', 'GEAR MOTOR 230.440', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(29, '025  LD-1 Plant', '5924A0316', 'SPL MOTR;CASTER 1 OLD CDRT MOTOR ,WEG BR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(30, '025  LD-1 Plant', '5761A0089', 'ELECT BOX;JUNCTION BOX,24VDC,BASE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(31, '025  LD-1 Plant', '5894A1133', 'GEARBOX;HELICAL ,BTPL/GB/103/R-30.87/1/N', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(32, '025  LD-1 Plant', '5495A0160', 'CNTRLR;MASTER CONTROLLER,220VAC,DIGITAL', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(33, '025  LD-1 Plant', '5620A1052', 'PLC SPR;ETHERNET MODULE,ALLEN BRADLEY', '025 LDE2                       LD1 DSI elect', 22, 'NOS', '2023-03-31', NULL),
(34, '025  LD-1 Plant', '0256A1731', '4000A 3POLE, U-POWER ACB', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(35, '025  LD-1 Plant', '5620A2881', 'CONTROL LOGIX PROCESSOR ,ROCKWELL ,1756-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(36, '025  LD-1 Plant', '5929A0003', 'BRAK MTR;BRAKE MOTORS,0.37KW', '025 L1EW                       Electrical Wards', 12, 'NOS', '2023-03-31', NULL),
(37, '025  LD-1 Plant', '5717A0418', 'LT CBL;4,ANNEALED TINNED COPPER', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(38, '025  LD-1 Plant', '5924A0173', 'SPL MOTR;DRT MOTOR,WEG', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(39, '025  LD-1 Plant', '5507A0020', 'BRAKE;400MM,THRUSTER,HYDRAULIC,415VAC', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(40, '025  LD-1 Plant', '5563A2153', 'INSL. SUPP. ARM PEDESTAL ,20704227 ,1 ,N', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(41, '025  LD-1 Plant', '5580A0941', 'COUPLING;COUPLING WITH BRAKE DRUM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(42, '025  LD-1 Plant', '5956A1287', 'INST SPR;MAGNETIC FLOW METER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(43, '025  LD-1 Plant', '5717A0556', 'LT CBL;10,1.5MM2,ANNEALED TINNED COPPER', '025 LDE2                       LD1 DSI elect', 1000, 'M', '2023-03-31', NULL),
(44, '025  LD-1 Plant', '0486A2171', 'C T MOTOR FOR CC3 WITH BRAKE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(45, '025  LD-1 Plant', '5625A0252', 'LV VFD;140KVA,LONG TRAVEL,THREE,415V,6', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(46, '025  LD-1 Plant', '0403A0622', 'Electromagnetic type Flowmeter, 50P65', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(47, '025  LD-1 Plant', '5493A0149', 'FLOW MTR;6 - 12BAR,WATER/LIQUID', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(48, '025  LD-1 Plant', '5510A0007', 'BRKE DRM;400MM,SHAFT,HYDRAULIC', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(49, '025  LD-1 Plant', '5623A0366', 'MOTOR&ACCES', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(50, '025  LD-1 Plant', '6045A0136', 'SPL CBL;CABLES FOR SERVO MOTOR ,LAPP IND', '025 LDE2                       LD1 DSI elect', 998, 'M', '2023-03-31', NULL),
(51, '025  LD-1 Plant', '5956A2120', 'HUMIDITY CUM TEMP. TRANSMITTER ,SENSIRIO', '025 LDE2                       LD1 DSI elect', 65, 'NOS', '2023-03-31', NULL),
(52, '025  LD-1 Plant', '5924A0172', 'SPL MOTR;TUNDISH CAR LIFTING MOTOR,WEG', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(53, '025  LD-1 Plant', '5620A1641', 'PLC SPR;CONTROL LOGIX PROCESSOR', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(54, '025  LD-1 Plant', '5540A1811', 'IO CARD ,REMOTE I/O ASSEMBLY, 24 DO, 20', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(55, '025  LD-1 Plant', '6098A0340', 'DRV MODL;4.5 KVA,KOLLMORGEN ,SERVO AMPLI', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(56, '025  LD-1 Plant', '5273A0273', 'CC1 CT DRAG CHAIN ,IGUS (INDIA) PRIVATE.', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(57, '025  LD-1 Plant', '5625A0257', 'LV VFD;70KVA,LONG TRAVEL,THREE,415V,6', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(58, '025  LD-1 Plant', '5620A2361', 'REDUNDANCY MODULE ,CONTROL LOGIX ,1756-R', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(59, '025  LD-1 Plant', '0453A0227', 'CABLES FOR STEEL/SLAG CAR CRD CABLE DRUM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(60, '025  LD-1 Plant', '5495A0197', 'CNTRLR;JOYSTICK CONTROLLER ,24 VDC,DIGIT', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(61, '025  LD-1 Plant', '5626A0276', 'OLTC DRIVE MECHANISM ,EASUN MR ,ALSTOM ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(62, '025  LD-1 Plant', '5607A0193', 'RELAY,NO MODIFIER,3P ACB WITH CT,5%,MICR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(63, '025  LD-1 Plant', '5717A1013', 'LT CBL;5 ,CSP-FRLSH ,ANNEALED TINNED COP', '025 LDE2                       LD1 DSI elect', 928, 'M', '2023-03-31', NULL),
(64, '025  LD-1 Plant', '5620A1105', 'PLC SPR;SOFTWARE,ROCKWELL,9324RLD300ENM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(65, '025  LD-1 Plant', '5965A4436', 'MOTOR MOUNTING BRACKET ,SHA114 ,T. M. EN', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(66, '025  LD-1 Plant', '5924A0616', 'SPL MOTR;SERVO MOTOR ,KOLMORGEN ,AKM52G-', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(67, '025  LD-1 Plant', '5521A0446', 'THRUSTER ,SIBRE ,SIBRE ,KOM NR-172631 ,E', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(68, '025  LD-1 Plant', '5495A0244', 'CNTRLR;JOYSTICK CONTROLLER ,48 TO 265 VD', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(69, '025  LD-1 Plant', '5717A0699', 'LT CBL;4 ,6 MM2,COPPER ,GLASS FIBRE ,FLE', '025 LDE2                       LD1 DSI elect', 1500, 'M', '2023-03-31', NULL),
(70, '025  LD-1 Plant', '5924A0123', 'SPL MOTR;SCIM,ABB,M2BA315SMA6', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(71, '025  LD-1 Plant', '0853A4860', '1250A ACB C-Power', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(72, '025  LD-1 Plant', '5620A0159', 'PLC SPR,CONTROLLOGIX PROCESSOR,ALLN BRAD', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(73, '025  LD-1 Plant', '5929A0057', 'BRAK MOTR;BRAKE MOTORS ,11 KW,WEG ,WFF2-', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(74, '025  LD-1 Plant', '5924A0102', 'SPL MOTR;COMMON DISCHARE ROLLER TABLE', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(75, '025  LD-1 Plant', '6098A0125', 'DRV MODL;11 KW,ALLEN BRADLEY ,POWERFLEX', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(76, '025  LD-1 Plant', '5924A0124', 'SPL MOTR;TURRET MOTOR,DANIELI SERVICE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(77, '025  LD-1 Plant', '0403A1063', 'Magnetic Flowmeter Flowtube 2.5-inch', '025 LDE2                       LD1 DSI elect', 1, 'PAA', '2023-03-31', NULL),
(78, '025  LD-1 Plant', '5929A0046', 'BRAK MOTR;CARRIAGE MOTOR ,1.1 KW,SMS CON', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(79, '025  LD-1 Plant', '5700A0946', 'FLD SNSR;Vibration Sensor ,BENTALY NAVAD', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(80, '025  LD-1 Plant', '1047A2611', 'ACS800 DRIVE FOR TILTER', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(81, '025  LD-1 Plant', '5507A0236', 'BRAK;13 IN,ELECTROMAGNETIC ,DRUM ,AC ,3', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(82, '025  LD-1 Plant', '5924A0744', 'SPL MOTR;RRT MOTOR ,SEW EURODRIVES ,DRN1', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(83, '025  LD-1 Plant', '5542A0014', 'DRV SPR,11 K W POWR FLX DRIVE WITH HIM,R', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(84, '025  LD-1 Plant', '6098A0138', 'DRV MODL;40 KVA,ABB ,ACS800 ,380-415 V,A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(85, '025  LD-1 Plant', '5924A0213', 'SPL MOTR;CC3 DUMMY BAR MOTOR', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(86, '025  LD-1 Plant', '5540A0890', 'ELTRNC CARD;DATA ACQUISITION SYSTEM', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(87, '025  LD-1 Plant', '1586A0609', 'LOGIX 5563 PROCESSOR', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(88, '025  LD-1 Plant', '6129A0199', '3 D RADAR LEVEL TRANSMITTER ,LIMACO ,ULM', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(89, '025  LD-1 Plant', '5557A0037', 'BRDG RCTFR;DIODE BRIDGE RECTIFIER,TWO', '025 L1EW                       Electrical Wards', 17, 'NOS', '2023-03-31', NULL),
(90, '025  LD-1 Plant', '5900A1360', 'AC MOTR;132KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(91, '025  LD-1 Plant', '1889A1096', 'BRAKE DRUM COUPLING(LIFTING DRIVE)', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(92, '025  LD-1 Plant', '5532A0275', 'GAS ANLYR SPR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(93, '025  LD-1 Plant', '5717A0554', 'LT CBL;10,ANNEALED TINNED COPPER', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(94, '025  LD-1 Plant', '5924A0083', 'SPL MOTR;SCIM,SEW EURO DRIVE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(95, '025  LD-1 Plant', '5539A0093', 'CHRGR;PLANTE ,FLOAT CUM BOOST ,YES ,50 A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(96, '025  LD-1 Plant', '1586A1166', 'LOGIX 5563 PROCESSOR WITH', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(97, '025  LD-1 Plant', '5620A1046', 'PLC SPR;ANALOG INPUT MODULE', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(98, '025  LD-1 Plant', '5540A1307', 'CONTROLLER ,AMPLIFIER CARD ,REXROTH ,VT-', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(99, '025  LD-1 Plant', '6045A0145', 'SPL CBL;RESOLVER SIGNAL CABLE ,SMS CONCA', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(100, '025  LD-1 Plant', '0973A0217', '\"PLC IAI-1 ANALOG IN 4-20MA,DESIGNATIONS', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(101, '025  LD-1 Plant', '1041A3075', 'INITIATEUR, CCS, 4460, V2 , TESTER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(102, '025  LD-1 Plant', '5717A0736', 'LT CBL;3CX70 + 3CX16 ,ANNEALED TINNED CO', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(103, '025  LD-1 Plant', '5858A0207', 'MODUL;1.25 A,TOCB RIO ,12 ,LOGIKA ,10976', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(104, '025  LD-1 Plant', '5620A0324', 'PLC SPR,ANALOG INPUT MODULE,SIEMENS,PART', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(105, '025  LD-1 Plant', '5620A0387', 'PLC SPR,RAM MEMORY CARD,SIEMENS,6ES7952-', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(106, '025  LD-1 Plant', '5669A2018', 'DRIVING SHEAVE ,OTIS ,LIFT ,OTIS ELEVATO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(107, '025  LD-1 Plant', '5496A0415', 'PR TRNTR;4 TO 20 MA DC WITH DIGITAL COM', '025 LDE2                       LD1 DSI elect', 17, 'NOS', '2023-03-31', NULL),
(108, '025  LD-1 Plant', '5924A0742', 'SPL MOTR;TAT PINCH ROLL MOTOR ,SEW EUROD', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(109, '025  LD-1 Plant', '5669A1939', '5/8\" HOIST ROPE 2365 GALVANIS ,OTIS ,LIF', '025 LDE2                       LD1 DSI elect', 570, 'M', '2023-03-31', NULL),
(110, '025  LD-1 Plant', '5900A1354', 'AC MOTR;110KW,415 Â± 10%V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(111, '025  LD-1 Plant', '0407A0463', 'DP FLOW TRANSMITTER (0-4000MMWC)', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(112, '025  LD-1 Plant', '0256B0028', 'AIR CIRCUIT BREAKER 3200A(EDO)TYPE CN-3T', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(113, '025  LD-1 Plant', '5900A2021', 'AC MOTR;110 KW,415 Â± 10% V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(114, '025  LD-1 Plant', '6133A0128', 'PHOTOMULTIPLIER UNIT 2\' FOR L ,BERTHOLD', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(115, '025  LD-1 Plant', '5900A2025', 'AC MOTR;67 KW,415 Â± 10%  V,SLIP RING ,TI', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(116, '025  LD-1 Plant', '5620A1045', 'PLC SPR;DIGITAL OUTPUT MODULE', '025 LDE2                       LD1 DSI elect', 13, 'NOS', '2023-03-31', NULL),
(117, '025  LD-1 Plant', '5717A1016', 'LT CBL;12 ,PVC-ST2-FRLSH ,COPPER .,1.5 M', '025 LDE2                       LD1 DSI elect', 2083, 'M', '2023-03-31', NULL),
(118, '025  LD-1 Plant', '6133A0127', 'PREAMPLIFIER BOARD FOR LB 6752 ,BERTHOLD', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(119, '025  LD-1 Plant', '5791A3341', 'SPL VALVE;XRP XD025S10A/1\" ,ACTUATED BAL', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(120, '025  LD-1 Plant', '5495A0123', 'CNTRLR;JOYSTICK CONTROLLER,110VAC', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(121, '025  LD-1 Plant', '5620A2267', 'PLC SPR;ETHERNET ADAPTER MODULE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(122, '025  LD-1 Plant', '5523A0170', 'FAN;TUBULAR FAN ,AC ,THREE ,415 V,PEDEST', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(123, '025  LD-1 Plant', '6183A0052', 'MASTER CONTROLLER;110 VAC,16 A,2-0-2 ,SI', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(124, '025  LD-1 Plant', '5885A0324', 'PROXMTY;INDUCTIVE,8MM,10-140/20-140V', '025 L1EW                       Electrical Wards', 53, 'NOS', '2023-03-31', NULL),
(125, '025  LD-1 Plant', '0763A0437', 'PANEL A/C 1400 KCAL/HR WERNER FINLEY', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(126, '025  LD-1 Plant', '5650A0202', 'GEAR MOTR;1.6 KW,415 V,1400 ,B3  ,S1 ,F', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(127, '025  LD-1 Plant', '5924A0292', 'SPL MOTR;UNBALANCE MOTOR EXCITER ,INTERN', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(128, '025  LD-1 Plant', '5553A0065', 'CAPACITOR,FILM,2X1300MFD,2660V,2660V,SCR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(129, '025  LD-1 Plant', '5872A1709', 'SW GR&CB SPR,PAD LOCKING KIT,SCNEDR ELEC', '025 LDE2                       LD1 DSI elect', 95, 'NOS', '2023-03-31', NULL),
(130, '025  LD-1 Plant', '5620A2753', 'PROFIBUS DP INTERFACE MODULE ,PRO SOFT ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(131, '025  LD-1 Plant', '6183A0061', 'MASTER CONTROLLER;415 VAC,10 A,1-0-1 ,SI', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(132, '025  LD-1 Plant', '5540A1811', 'IO CARD ,REMOTE I/O ASSEMBLY, 24 DO, 20', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(133, '025  LD-1 Plant', '0973A0259', 'IGNITION ELECTRODE', '025 LDE2                       LD1 DSI elect', 16, 'NOS', '2023-03-31', NULL),
(134, '025  LD-1 Plant', '5700A0812', 'FLD SNSR;OPTICAL BARRIER ,DELTA ,230V AC', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(135, '025  LD-1 Plant', '5490A0377', 'DISOBOX CONTROLLER ,SCHENCK PROCESS INDI', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(136, '025  LD-1 Plant', '5475A0126', 'CTRL VLV;2IN,CONTROL VALVE,SS316', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(137, '025  LD-1 Plant', '5475A0127', 'CTRL VLV;2IN,LINEAR,SS316', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(138, '025  LD-1 Plant', '5475A0129', 'CTRL VLV;2IN,LINEAR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(139, '025  LD-1 Plant', '5620A2019', 'PLC SPR;CPU CARD,SIEMENS', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(140, '025  LD-1 Plant', '5924A0102', 'SPL MOTR;COMMON DISCHARE ROLLER TABLE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(141, '025  LD-1 Plant', '5669A0498', 'LFT SPR;Governor Assy Xsq115-01 0.70M/', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(142, '025  LD-1 Plant', '5620A0986', 'PLC SPR;DIGITAL OUTPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(143, '025  LD-1 Plant', '5607A0712', 'RELAY;NUMERICAL,DIFFERENTIAL PROTECTION', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(144, '025  LD-1 Plant', '5580A1885', 'COUPLNG;STOPPER MOTOR COUPLING ,FLEXIBLE', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(145, '025  LD-1 Plant', '5669A1519', 'CABLE FLAT 24CORE 20*0.75 ,THYSSENKRUPP', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(146, '025  LD-1 Plant', '5620A0987', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(147, '025  LD-1 Plant', '0910A1502', 'STEEL CABLE CARRIER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(148, '025  LD-1 Plant', '5540A0891', 'ELTRNC CARD;DATA ACQUISITION SYSTEM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(149, '025  LD-1 Plant', '5574A0047', 'ACB;2500A,3,690V', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(150, '025  LD-1 Plant', '5107A0038', 'DSPLY SCRN;65IN,LED MONITOR,220VAC', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(151, '025  LD-1 Plant', '5607A0951', 'RELAY;MICROPROCESSOR BASED RELAY ,EARTH', '025 L1EW                       Electrical Wards', 4, 'SET', '2023-03-31', NULL),
(152, '025  LD-1 Plant', '6098A0182', 'DRV MODL;5.5 KW,SIEMENS ,G120 ,380 TO 48', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(153, '025  LD-1 Plant', '0479A0539', 'CURRENT TRANSFORMER', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(154, '025  LD-1 Plant', '5900A1068', 'AC MOTR;45KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(155, '025  LD-1 Plant', '5620A0315', 'PLC SPR,ANALOG OUTPUT MODULE,SIEMENS,6ES', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(156, '025  LD-1 Plant', '5929A0013', 'BRAK MTR;BRAKE MOTORS,850KW,DEMAG', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(157, '025  LD-1 Plant', '5508A0342', 'ENCODR;WIRE DRAW ENCODER ,KUBLER ,D8.C60', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(158, '025  LD-1 Plant', '5791A3345', 'SPL VALVE;2XP FSJ3.5N EXII2GD EEXIAIICT6', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(159, '025  LD-1 Plant', '5717A0682', 'LT CBL;8 ,0.75 MM2,Copper Class-5 to IS', '025 LDE2                       LD1 DSI elect', 1000, 'M', '2023-03-31', NULL),
(160, '025  LD-1 Plant', '5900A1229', 'AC MOTR;90KW,415 +10% -15%VAC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(161, '025  LD-1 Plant', '5493A0280', 'FLW MTR;20 KG/CM2,LIQUID ,ELECTOMAGNETIC', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(162, '025  LD-1 Plant', '0973A0262', 'FLAME RELAY SM592.2 110V50/60 HZ TS =5 S', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(163, '025  LD-1 Plant', '1586A0455', 'I/O CONTROL BOARD, COATED', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(164, '025  LD-1 Plant', '5924A0741', 'SPL MOTR;TART MOTOR ,SEW EURODRIVES ,DRN', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(165, '025  LD-1 Plant', '5475A0131', 'CTRL VLV;1.5IN,LINEAR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(166, '025  LD-1 Plant', '5475A0132', 'CTRL VLV;1.5IN,LINEAR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(167, '025  LD-1 Plant', '5894A1313', 'GEARBOX;HELICAL ,BTPL/NAW/GB-R103/41.2/1', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(168, '025  LD-1 Plant', '5512A0143', 'LOAD CELL ,SCHENCK PROCESS ,WDI 100T - 0', '025 LDE1                       Trafic storeElec', 1, 'NOS', '2023-03-31', NULL),
(169, '025  LD-1 Plant', '1047A0411', 'UNIDRIVE SP OF 11 KW', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(170, '025  LD-1 Plant', '5701A0254', 'EL SKT/PLG;400 A,BRASS ,5 ,PANEL MOUNTED', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(171, '025  LD-1 Plant', '6131A0024', 'DISPLAY FOR MAG FLOW ,YOKOGAWA ,F9802JA', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(172, '025  LD-1 Plant', '5620A0214', 'PLC SPR,RTD INPUT MODULE,ALLEN BRADLEY,1', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(173, '025  LD-1 Plant', '5542A2274', 'CUVC DRIVER CARD ,SIEMENS ,SIMOVERT MAST', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(174, '025  LD-1 Plant', '5508A0550', 'ENCODR;INCREMENTAL ROTARY ENCODER ,INDUC', '025 L1EW                       Electrical Wards', 1, 'PCE', '2023-03-31', NULL),
(175, '025  LD-1 Plant', '5669A0078', 'LFT SPR;TENSION DEVICE PULLEY D240', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(176, '025  LD-1 Plant', '0403A0425', 'MINIATURE FLOW METER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(177, '025  LD-1 Plant', '5701A0253', 'EL SKT/PLG;400 A,BRASS ,5 ,PLUG ,230/415', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(178, '025  LD-1 Plant', '1048A0259', 'E NET PROCESSOR SLC 32K', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(179, '025  LD-1 Plant', '5620A0890', 'PLC SPR;DIGITAL INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(180, '025  LD-1 Plant', '5900A1216', 'AC MOTR;75KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(181, '025  LD-1 Plant', '5613A0181', 'LMT SWTCH;ROLLER LEVER,HEAVY', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(182, '025  LD-1 Plant', '5976A0001', 'PAINT,SPECIAL;MARINE CHOCKING', '025 LDE2                       LD1 DSI elect', 16, 'PAC', '2023-03-31', NULL),
(183, '025  LD-1 Plant', '5620A0226', 'PLC SPR,EN RUSB CARD KIT DRIVEWINDOW 2.3', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(184, '025  LD-1 Plant', '1586A1039', 'MAIN CONTROL BOARD', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(185, '025  LD-1 Plant', '5620A1468', 'PLC SPR;ET200M, REDUNDANCY MODULE', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(186, '025  LD-1 Plant', '6098A0135', 'DRV MODL;2.2 KW,CONTROL TECHNIQUES ,COMM', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(187, '025  LD-1 Plant', '6045A0146', 'SPL CBL;AC SERVO POWER CABLE ,SMS CONCAS', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(188, '025  LD-1 Plant', '5620A1183', 'PLC SPR;CPU,SIEMENS,6ES73152AG100AB0', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(189, '025  LD-1 Plant', '5620A0166', 'PLC SPR,REDUNDANCY MODULE,ALLEN BRADELEY', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(190, '025  LD-1 Plant', '5620A1279', 'PLC SPR;ANALOG OUTPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(191, '025  LD-1 Plant', '0910A1293', 'MOTOR', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(192, '025  LD-1 Plant', '0513A0833', 'Milliamps Process Clamp Meters', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(193, '025  LD-1 Plant', '0256A0438', '150A  45KA MCCB 3P WITH TRIP UNIT STR53U', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(194, '025  LD-1 Plant', '5490A0281', 'WEIGHING INDICATOR ,SARTORIUS ,PR5510/00', '025 LDE2                       LD1 DSI elect', 3, 'SET', '2023-03-31', NULL),
(195, '025  LD-1 Plant', '5797A0270', 'FEROUS METAL;PLATE,AISI 310,420MM,476MM', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(196, '025  LD-1 Plant', '5620A1717', 'PLC SPR;RTD MODULE,ALLEN BRADLEY', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(197, '025  LD-1 Plant', '5475A0152', 'CTRL VLV;0.5IN,LINEAR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(198, '025  LD-1 Plant', '5508A0140', 'ENCODER;INCREMENTAL ROTARY ENCODER', '025 L1EW                       Electrical Wards', 7, 'NOS', '2023-03-31', NULL),
(199, '025  LD-1 Plant', '6133A0125', 'CPU BOARD FOR GAMMA CAST DETEC ,BERTHOLD', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(200, '025  LD-1 Plant', '5620A1046', 'PLC SPR;ANALOG INPUT MODULE', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(201, '025  LD-1 Plant', '5890A0723', 'CONTCR;140A,3,110V,POWER,415V,S6,AC', '025 LDE2                       LD1 DSI elect', 17, 'NOS', '2023-03-31', NULL),
(202, '025  LD-1 Plant', '5509A0456', 'MCCB;630A,3,415VAC,50KA,AC,50HZ,2NO+2NC', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(203, '025  LD-1 Plant', '5900A2125', 'AC MOTR;5.5 KW,415 +10%,-15% V,SQUIRREL', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(204, '025  LD-1 Plant', '5971A0237', 'EPOXY BASED PROTECTIVE COATING ,LOCTITE', '025 LDE2                       LD1 DSI elect', 30, 'KG', '2023-03-31', NULL),
(205, '025  LD-1 Plant', '5537A0017', 'BATTERY,LEAD ACID,DC SOURCE FOR BREAKER,', '025 L190                       Vessel Elect str', 50, 'NOS', '2023-03-31', NULL),
(206, '025  LD-1 Plant', '0910A1758', 'HEAVY DUTY SLIPRING  UNIT MADE OF SHEET', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(207, '025  LD-1 Plant', '5332A0008', 'ENRGY MTR;ENERGY METER,THREE,110VAC', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(208, '025  LD-1 Plant', '5895A0026', 'MEGGR;MEGGER NOS,FLUKE ,1550B ,NO SPECIA', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(209, '025  LD-1 Plant', '5956A4763', 'INDUCTIVE PROXIMITY SENSOR ,PEPPERL+FUCH', '025 L1EW                       Electrical Wards', 5, 'PCE', '2023-03-31', NULL),
(210, '025  LD-1 Plant', '5045A0008', 'LDDR TRY;7750,130MM,13MM,94,106MM,250MM', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(211, '025  LD-1 Plant', '5542A0009', 'DRV SPR,DE-IONIZER,ABB,3BHL001433P0001,P', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(212, '025  LD-1 Plant', '0367A0101', 'ITH FLASHER 120 WATT', '025 LDE2                       LD1 DSI elect', 35, 'NOS', '2023-03-31', NULL),
(213, '025  LD-1 Plant', '5593A0057', 'TEMP TRNSMTR', '025 LDE2                       LD1 DSI elect', 60, 'NOS', '2023-03-31', NULL),
(214, '025  LD-1 Plant', '5900A1968', 'AC MOTR;30 KW,415 V,SQUIRREL CAGE ,COOLI', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(215, '025  LD-1 Plant', '5893A0420', 'CONTACT PAD COPPER RING ,PRECISION SPARE', '025 LDE2                       LD1 DSI elect', 13, 'NOS', '2023-03-31', NULL),
(216, '025  LD-1 Plant', '5885A0241', 'PROXIMITY;INDUCTIVE SWITCH,40MM,24-240V', '025 L1EW                       Electrical Wards', 16, 'NOS', '2023-03-31', NULL),
(217, '025  LD-1 Plant', '5620A2167', 'PLC SPR;ETHERNET ADAPTER MODULE', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(218, '025  LD-1 Plant', '5508A0319', 'ENCODR;HOLLOW SHAFT INC ENCODER ,LIKA ,C', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(219, '025  LD-1 Plant', '0546A2572', 'ELECTRONIC COMPONENTS FOR  ORECICON III', '025 LDE2                       LD1 DSI elect', 2, 'SET', '2023-03-31', NULL),
(220, '025  LD-1 Plant', '0945A0669', 'Actuator type Â¿ IQ Range,Syncropak', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(221, '025  LD-1 Plant', '5900A2001', 'AC MOTR;55 KW,415 Â± 10%  V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(222, '025  LD-1 Plant', '5620A1763', 'PLC SPR;S7-300, DIGITAL OUTPUT SM322', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(223, '025  LD-1 Plant', '1329A0139', 'DEIONIZER, Q-0730-A', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(224, '025  LD-1 Plant', '1329A0265', 'Astro1000 with source output', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(225, '025  LD-1 Plant', '5507A0109', 'BRAK;13 IN,ELECTROMAGNETIC SHUNT ,DC ,SI', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(226, '025  LD-1 Plant', '5540A1371', 'HYDRAULIC ,AMPLIFIER CARD ,REXROTH ,VT-V', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(227, '025  LD-1 Plant', '1041A2383', 'IGBT-TRANSISTORT MODULE 300A', '025 LD12                       LD#1 DSI Store', 4, 'NOS', '2023-03-31', NULL),
(228, '025  LD-1 Plant', '5512A0166', 'TUNDISH LOAD CELL ,SCHENCK PROCESS ,WDI', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(229, '025  LD-1 Plant', '0109A1075', 'ABB ACS1000 MV DRIVE CLAMPING CAPACITOR', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(230, '025  LD-1 Plant', '0249A0324', 'TILT MASTER CONTROLLER FOR STEEL CAR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(231, '025  LD-1 Plant', '5542A0138', 'DRV SPR,DBU,SIEMENS,6SE7032-7EB87-2DA1,S', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(232, '025  LD-1 Plant', '5717A1015', 'LT CBL;1 ,CSP-FRLSH ,ANNEALED TINNED COP', '025 L190                       Vessel Elect str', 83, 'M', '2023-03-31', NULL),
(233, '025  LD-1 Plant', '0291A4336', '3M Vortex Cooler', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(234, '025  LD-1 Plant', '5542A0533', 'DRV SPR;IGBT,ABB', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(235, '025  LD-1 Plant', '1047A1846', '20-COMM-C Powerflex Control', '025 LDE2                       LD1 DSI elect', 9, 'NOS', '2023-03-31', NULL),
(236, '025  LD-1 Plant', '5262A0016', 'POWER SUPPLY,100-240V,24V,20A,2938620,PH', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(237, '025  LD-1 Plant', '5607A0699', 'RELAY;NUMERICAL,MOTOR PROTECTION,+/-2%', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(238, '025  LD-1 Plant', '6028A0010', 'POWER DISTRIBUTION ACCESSORIES', '025 LDE2                       LD1 DSI elect', 1, 'EA', '2023-03-31', NULL),
(239, '025  LD-1 Plant', '5540A1368', 'HYDRAULIC ,AMPLIFIER CARD ,REXROTH ,VT-V', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(240, '025  LD-1 Plant', '0477A0160', 'POTENTIAL TRANSFORMER 33000/V3/110/V3', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(241, '025  LD-1 Plant', '0244A1038', 'UNDER VOLTAGE RELAY', '025 LD12                       LD#1 DSI Store', 9, 'NOS', '2023-03-31', NULL),
(242, '025  LD-1 Plant', '0249A0325', 'TILT MASTER CONTROLLER FOR SLAG CAR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(243, '025  LD-1 Plant', '1048A0911', 'POWER SUPPLY BOARD', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(244, '025  LD-1 Plant', '2254A0020', 'LF#2 STEEL CAR HRD TORQUE MOTORS', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(245, '025  LD-1 Plant', '6133A0126', 'HIGH VOLTAGE GENERATOR WITH PM ,BERTHOLD', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(246, '025  LD-1 Plant', '0853A5050', 'ACB Handling Trolley', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(247, '025  LD-1 Plant', '0416A2365', 'Purge Sequence Controller', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(248, '025  LD-1 Plant', '0855A0283', 'SELENIUM RECTIFIER 42 A, PIV 1200V', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(249, '025  LD-1 Plant', '5924A0111', 'SPL MOTR;WITHDRAWL MOTOR,WATT DRIVE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(250, '025  LD-1 Plant', '5532A0568', 'CO DETECTOR ,ADAGE ,GAS ANALYZER ACCESSO', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(251, '025  LD-1 Plant', '5521A0345', 'BRAKE PANEL ,BCH ELECTRIC LIMITED ,BCH ,', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(252, '025  LD-1 Plant', '5964A0061', 'PNL;WELDER PANEL ,THREE ,415 V,MCCB ,FLO', '025 LDE2                       LD1 DSI elect', 9, 'NOS', '2023-03-31', NULL),
(253, '025  LD-1 Plant', '5703A0018', 'SPL GEARBOX;WORM,11.93KW,20.9:1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(254, '025  LD-1 Plant', '5475A0204', 'CONT VALV;1.5 IN,LINEAR ,SS 316 Reverseb', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(255, '025  LD-1 Plant', '5900A1330', 'AC MOTR;110KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(256, '025  LD-1 Plant', '5929A0027', 'BRAK MOTR;BRAKE MOTORS ,120 KW,DEMAG ,KB', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(257, '025  LD-1 Plant', '0973A0399', 'DUCT,VACUUM,ROTATION K7,9800', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(258, '025  LD-1 Plant', '5540A1094', 'ELTNC CARD;PLC,COMMUNICATION PROCESSOR', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(259, '025  LD-1 Plant', '5669A2060', 'LIMIT SWITCH DP ,OTIS ,LIFT ,OTIS ELEVAT', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(260, '025  LD-1 Plant', '5872A2419', 'ACB TROLLEY UPTO 4000 A ,L&T ,AIR CIRCUI', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(261, '025  LD-1 Plant', '1041A3384', 'CPU MODULE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(262, '025  LD-1 Plant', '5956A0633', 'INST SPR;VIBRATION SENSOR VERTICAL', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(263, '025  LD-1 Plant', '5956A0634', 'INST SPR;VIBRATION SENSOR HORIZONTAL', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(264, '025  LD-1 Plant', '1349A0349', 'DRAG CHAIN FOR CC2 CROSS PUSHER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(265, '025  LD-1 Plant', '5620A1054', 'PLC SPR;ANALOG OUTPUT MODULE', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(266, '025  LD-1 Plant', '5620A1054', 'PLC SPR;ANALOG OUTPUT MODULE', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(267, '025  LD-1 Plant', '5900A1978', 'AC MOTR;30 KW,415 Â± 10%  V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(268, '025  LD-1 Plant', '5872A0041', 'SW GR&CB SPR,COIL,IC,VIBRO FEEDER,1-03-0', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(269, '025  LD-1 Plant', '5872A2677', 'VBT SOLENOID COILS FOR VBT ,JOSLYN HI VO', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(270, '025  LD-1 Plant', '5700A0582', 'FIELD SNSR;LASER,LEUZE ELECTRONIC,24VDC', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(271, '025  LD-1 Plant', '0945A0013', 'CONTROL VALVE FOR CALCIUM CARBIDE.', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(272, '025  LD-1 Plant', '0910A1506', 'STEEL CABLE CARRIER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(273, '025  LD-1 Plant', '5717A0401', 'LT CBL;4,6MM2,COPPER,TPE,POWER', '025 L1EW                       Electrical Wards', 209, 'M', '2023-03-31', NULL),
(274, '025  LD-1 Plant', '5508A0249', 'ENCODR;INCREMENTAL ROTARY ENCODER ,LIKA', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(275, '025  LD-1 Plant', '1877A1738', 'Governor Assy Xsq115-13 0.75M/S D8 Car S', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(276, '025  LD-1 Plant', '2254A0021', 'LF#3 STEEL CARD HRD MOTOS', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(277, '025  LD-1 Plant', '5508A0269', 'ENCODR;INCREMENTAL ROTARY ENCODER ,BAUME', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(278, '025  LD-1 Plant', '5956A1492', 'INST SPR;TEMP & OXY MEASUREMENT PROBE F', '025 LDE2                       LD1 DSI elect', 224, 'NOS', '2023-03-31', NULL),
(279, '025  LD-1 Plant', '6183A0017', 'MASTER CONTROLLER;400 VAC/DC,16 A,4-0-4', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(280, '025  LD-1 Plant', '0712A0188', '415V ELECT.ACTUATOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(281, '025  LD-1 Plant', '5960A0086', 'FRP BARRICATION ,2X1X1 M,FRP ,FRP BARRIC', '025 L190                       Vessel Elect str', 10, 'NOS', '2023-03-31', NULL),
(282, '025  LD-1 Plant', '5526A0019', 'ELECT INSLTR;GLASS,INSULATOR,1100V', '025 LDE2                       LD1 DSI elect', 72, 'NOS', '2023-03-31', NULL),
(283, '025  LD-1 Plant', '1047A0653', 'STEAM EXHAUST FAN,55 KW', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(284, '025  LD-1 Plant', '5620A2468', 'PROFIBUS DP INTERFACE MODULE ,SIEMENS ,6', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(285, '025  LD-1 Plant', '0973A0261', 'DETECTION ELECTRODE', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(286, '025  LD-1 Plant', '5620A0390', 'PLC SPR,UR2 RACK,SIEMENS,6ES7400-1JA01-0', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(287, '025  LD-1 Plant', '1586A0526', 'CPU 414-2DP', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(288, '025  LD-1 Plant', '0517A0695', 'INDUCTIVE PROXIMITY', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(289, '025  LD-1 Plant', '0571A1047', 'UNBALANCED MOTOR EXCITER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(290, '025  LD-1 Plant', '6028A0158', 'PWR DSTBN PNL;TERMINAL BLOCK ,PHOENIX CO', '025 L1EW                       Electrical Wards', 500, 'NOS', '2023-03-31', NULL),
(291, '025  LD-1 Plant', '5262A0212', 'POWER SUPPLY;100-240V,24VDC,40A', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(292, '025  LD-1 Plant', '5262A0213', 'POWER SUPPLY;100-240V,24VDC,20A', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(293, '025  LD-1 Plant', '0825A0140', 'INTECONT PLUS FOR  Belt Scale,', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(294, '025  LD-1 Plant', '5965A4503', 'CYLINDER AIR 1.63 BORE X 7 STK ,617-771', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(295, '025  LD-1 Plant', '5520A0036', 'ACTR ACC,POSITIONER,ARCA,POSITIONER,ARCA', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(296, '025  LD-1 Plant', '0088A0379', 'JB WITH CONNECTOR SYSTEM FOR TCM', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(297, '025  LD-1 Plant', '5475A0070', 'CNTRL VALVE;1IN,MODIFIED EQUAL %', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(298, '025  LD-1 Plant', '5475A0068', 'CNTRL VALVE;3IN,MODIFIED EQUAL %', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(299, '025  LD-1 Plant', '5620A2308', 'PLC SPR;UPGRADE-PDA-V6-256 TO V6-1024', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(300, '025  LD-1 Plant', '5014A0080', 'ELECT SWTCH;6A,2NOS,SWITCH', '025 LDE2                       LD1 DSI elect', 110, 'NOS', '2023-03-31', NULL),
(301, '025  LD-1 Plant', '5475A0130', 'CTRL VLV;2IN,LINEAR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(302, '025  LD-1 Plant', '5475A0135', 'CTRL VLV;2IN,LINEAR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(303, '025  LD-1 Plant', '6015A0001', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(304, '025  LD-1 Plant', '5924A0268', 'SPL MOTR;CIRCULATION PUMP ,BEACON WEIR L', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(305, '025  LD-1 Plant', '5507A0038', 'BRAKE;150MM,ELECTROMAGNETIC,DRUM', '025 LDE2                       LD1 DSI elect', 3, 'SET', '2023-03-31', NULL),
(306, '025  LD-1 Plant', '5495A0195', 'CNTRLR;JOYSTICK CONTROLLER ,24 VDC,DIGIT', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(307, '025  LD-1 Plant', '5542A1209', 'DRIV SPR;COMMUNICATION MODULE,ABB', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(308, '025  LD-1 Plant', '5620A0152', 'PLC SPR,CONTROL NT RDUNDANT BRDG MODUL,A', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(309, '025  LD-1 Plant', '0580A1394', 'HYDRAULIC BUFFER', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(310, '025  LD-1 Plant', '1041A3298', 'CONTROL LOGIX SST CARD', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(311, '025  LD-1 Plant', '1041A2605', 'Quantum Ethernet TCP/IP Modbus 10/100m', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(312, '025  LD-1 Plant', '5620A0795', 'PLC SPR;COMPACTLOGIX PROCESSOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(313, '025  LD-1 Plant', '5900A0884', 'AC MOTR;37KW,415+10% -15%VAC', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(314, '025  LD-1 Plant', '5701A0097', 'ELECT SOCKT/PLG;125A,METALLIC,5,SOCKET', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(315, '025  LD-1 Plant', '5613A0359', 'LMT SW;ROLLER LEVER  ,HEAVY DUTY  NOS,FE', '025 L1EW                       Electrical Wards', 12, 'NOS', '2023-03-31', NULL),
(316, '025  LD-1 Plant', '5495A0106', 'CONTROLLER;JOYSTICK CONTROLLER,24VDC', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(317, '025  LD-1 Plant', '5475A0247', 'CONT VALV;80 NB,LINEAR ,SINGLE ,CAST GLO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(318, '025  LD-1 Plant', '0782A0206', 'Contact Block Oxy/celox type S, 4 core', '025 LDE2                       LD1 DSI elect', 300, 'NOS', '2023-03-31', NULL),
(319, '025  LD-1 Plant', '5620A0156', 'PLC SPR,EHTERNET/P CMMUNCTN BRDGE MDUL,A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(320, '025  LD-1 Plant', '5872A0852', 'SW GR&CB SPR,CONTACT ARM ASSEMBLY,SIEMEN', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(321, '025  LD-1 Plant', '5620A0491', 'PLC SPR,CH DIGITAL INPUT OUTPUT,SIEMENS,', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(322, '025  LD-1 Plant', '5085A0044', 'DISPLAY;48 IN,220 VAC,LED ,10 W,NO SPECI', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(323, '025  LD-1 Plant', '5513A0009', '7 SEG DSPLY;7-SEGMENT,RED,7,WHITE,75MM', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(324, '025  LD-1 Plant', '0782A0209', 'Contact Block for Oxy/Celox Typ B 4 Core', '025 LDE2                       LD1 DSI elect', 300, 'NOS', '2023-03-31', NULL);
INSERT INTO `t_stock_sap` (`sl`, `plant`, `mtcd`, `material`, `stloc`, `qty`, `unit`, `udt`, `uby`) VALUES
(325, '025  LD-1 Plant', '5669A1521', 'FLAT CABLE 6CORE_6G 0.75 ,THYSSENKRUPP ,', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(326, '025  LD-1 Plant', '5607A0051', 'RELAY,NO MODIFIER,PROTECTION,+/-10%,OVER', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(327, '025  LD-1 Plant', '1041A3775', 'ANALOG I/P MODULE:ANALOG I/P CARD', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(328, '025  LD-1 Plant', '5900A2055', 'AC MOTR;30 KW,415 +10%,-15% V,SQUIRREL C', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(329, '025  LD-1 Plant', '5859A0315', 'INSULATING MATL;SLEEVE', '025 L1EW                       Electrical Wards', 200, 'M', '2023-03-31', NULL),
(330, '025  LD-1 Plant', '5620A2458', 'SIWAREX U 2 CH ,SIEMENS ,7MH46011BA01 ,L', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(331, '025  LD-1 Plant', '5900A2794', 'AC MOTR;IE2 ,37 KW,415 Â± 10% V,SQUIRREL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(332, '025  LD-1 Plant', '5520A0434', 'MOTORISED ACTUATOR ,AUMA ,3094412005 ,AU', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(333, '025  LD-1 Plant', '5475A0200', 'CONT VALV;80 NB,LINEAR ,SS 316 Reversebl', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(334, '025  LD-1 Plant', '5620A1667', 'PLC SPR;CPU,HONEYWELL,2MLI-CPUU-CC,2.6', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(335, '025  LD-1 Plant', '1072A1397', 'BRAKE FOR WSU TOP ROLL MOTOR', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(336, '025  LD-1 Plant', '5262A0211', 'POWER SUPPLY;100-240V,24VDC,10A', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(337, '025  LD-1 Plant', '5607A1783', 'RELAY;NO SPECIAL FEATURES ,LOGIKA SYSTEM', '025 LDE2                       LD1 DSI elect', 40, 'NOS', '2023-03-31', NULL),
(338, '025  LD-1 Plant', '5885A0289', 'PROXMTY;INDUCTIVE SENSOR,20MM,10-30V', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(339, '025  LD-1 Plant', '1586A1227', '16-CH ANALOG INPUT MODULE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(340, '025  LD-1 Plant', '5563A0915', 'SPARE;COPPER DISC,LADLE FURNACE,LD1', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(341, '025  LD-1 Plant', '5620A0873', 'PLC SPR;ANALOG OUTPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(342, '025  LD-1 Plant', '5496A0348', 'PR TRNTR;LIQUID PRESSURE MEASUREMENT', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(343, '025  LD-1 Plant', '1072A0650', 'BRAKESYSTEM BRSR 100WAF161L6 FOR MOTOR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(344, '025  LD-1 Plant', '5620A0318', 'PLC SPR,DIGITAL OUTPUT MODULE,SIEMENS,6E', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(345, '025  LD-1 Plant', '5532A0268', 'GAS ANLYR SPR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(346, '025  LD-1 Plant', '0517A0666', 'INDUCTIVE SENSOR WITH EXTENDED TEMP.', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(347, '025  LD-1 Plant', '0416A1861', 'DS 50-P1112 SENSING RANGE 200...10,000', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(348, '025  LD-1 Plant', '5761A0071', 'ELECT BOX,BLANK,UP TO 1.1KV,WALL,OUTDOOR', '025 LDE2                       LD1 DSI elect', 32, 'NOS', '2023-03-31', NULL),
(349, '025  LD-1 Plant', '6204A0001', 'SHUNT FOR CONTACTOR;300 A,BRAIDED WIRE ,', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(350, '025  LD-1 Plant', '0447A1121', '10C X 1.0 Sq.mm', '025 LD12                       LD#1 DSI Store', 500, 'M', '2023-03-31', NULL),
(351, '025  LD-1 Plant', '1586A0571', 'ANALOG INPUT MODULE 1746-NI161', '025 LDE2                       LD1 DSI elect', 2, 'SET', '2023-03-31', NULL),
(352, '025  LD-1 Plant', '5475A0212', 'CONT VALV;2 IN,LINEAR ,SINGLE ,GLOBE ,AR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(353, '025  LD-1 Plant', '1615A0110', 'SLIPRING ASSLY.WITH EPOXY', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(354, '025  LD-1 Plant', '5542A2814', 'RADIAL COOLING FAN ,SIEMENS ,SIMOVERT MA', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(355, '025  LD-1 Plant', '1047A2422', 'DBR FOR VVF UNIDRIVE SP2403', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(356, '025  LD-1 Plant', '5475A0103', 'CTRL VLV;4IN,EQUAL PERCENTAGE,GUIDE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(357, '025  LD-1 Plant', '5620A2358', 'POWER SUPPLY ,CONTROL LOGIX ,1756-PA75 ,', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(358, '025  LD-1 Plant', '5669A0985', 'DOOR DRIVE WITH ENCODER ,THYSSENKRUPP ,L', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(359, '025  LD-1 Plant', '1047A0953', 'SOFT STARTER 132 KW', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(360, '025  LD-1 Plant', '0426A0474', 'ELECTRIC GAS COOLER 18519001,ADAGE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(361, '025  LD-1 Plant', '0808A2194', 'CONTROL CARD', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(362, '025  LD-1 Plant', '5449A0160', 'SUBMSBL PMP;25 M,40 M3/HR,VOLUTE ,2.5 KG', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(363, '025  LD-1 Plant', '5900A2925', 'AC MOTR;IE3 ,30 KW,415 +10%,-15% V,SQUIR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(364, '025  LD-1 Plant', '5620A1746', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(365, '025  LD-1 Plant', '5872A2237', 'CONTROL YOKE ,JOSLYN HI VOLTAGE ,33KV VI', '025 L1EW                       Electrical Wards', 7, 'NOS', '2023-03-31', NULL),
(366, '025  LD-1 Plant', '5486A0920', 'PNU VALVE;ASCO NUMATICS ,WP8320A184MO -1', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(367, '025  LD-1 Plant', '0910A1498', 'LT GEAR BOX', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(368, '025  LD-1 Plant', '5531A0617', 'CABLE GUIDE ASSLY ,BENGAL TECHNOCRAT ,BT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(369, '025  LD-1 Plant', '5900A2750', 'AC MOTR;IE2 ,5.5 KW,415 Â± 10% V,SQUIRREL', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(370, '025  LD-1 Plant', '1877A1744', 'MOTOR_DOOR DRIVE_TY-YVP90-9_NBSL', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(371, '025  LD-1 Plant', '5959A0478', 'PARALLEL-GRIPPER ,HERZOG ,8-2762-336397-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(372, '025  LD-1 Plant', '0112A0130', 'STANCE SG 1A', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(373, '025  LD-1 Plant', '5900A3653', 'AC MOTR;IE2 ,3.7 KW,415 Â± 10% V,SQUIRREL', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(374, '025  LD-1 Plant', '1041A2716', 'INVERTER GATE DRIVE BOARD (IGD1 BOARD)', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(375, '025  LD-1 Plant', '5607A0666', 'RELAY;ELECTROMECHANICAL,CONTROL CIRCUIT', '025 L1EW                       Electrical Wards', 30, 'NOS', '2023-03-31', NULL),
(376, '025  LD-1 Plant', '5620A0250', 'PLC SPR,32 BIT DIGITAL INPUT MODULE,SEIM', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(377, '025  LD-1 Plant', '5085A0090', 'DISPLAY;4  ,8  IN,100-240 VAC  V,7 SEGME', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(379, '025  LD-1 Plant', '5802A0048', 'PULLER;10  TON,2/3  ,30-250/310  ,SELF C', '025 LDE2                       LD1 DSI elect', 2, 'SET', '2023-03-31', NULL),
(380, '025  LD-1 Plant', '5648A0278', '8 PORT POE SWITCH ,CISCO ,SG300-10PP-K9', '025 LDE2                       LD1 DSI elect', 4, 'PCE', '2023-03-31', NULL),
(381, '025  LD-1 Plant', '5620A2376', 'ANALOG INPUT MODULE ,CONTROL LOGIX ,1794', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(382, '025  LD-1 Plant', '5929A0064', 'BRAK MOTR;SCIM ,2.2 KW,SEW EURODRIVE ,AM', '025 L1EW                       Electrical Wards', 1, 'PCE', '2023-03-31', NULL),
(383, '025  LD-1 Plant', '5620A2399', 'FLEX CONTROLNET REDUNDANT ,ALLEN BRADLEY', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(384, '025  LD-1 Plant', '5620A2399', 'FLEX CONTROLNET REDUNDANT ,ALLEN BRADLEY', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(385, '025  LD-1 Plant', '0416A1751', 'C C # 3 260 TON CRANE Analog Output unit', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(386, '025  LD-1 Plant', '5700A0383', 'FIELD SNSR;BATH TEMP. INDICATOR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(387, '025  LD-1 Plant', '0546A3667', 'SENSOR,TEMP NTC10K, M6', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(388, '025  LD-1 Plant', '0983A0277', 'AC  CENTRIFUGAL BLOWER', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(389, '025  LD-1 Plant', '5956A0487', 'INST SPR;SMART DP TRANSMITER,HONEYWELL', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(390, '025  LD-1 Plant', '5700A0902', 'FLD SNSR;OSIPROX SX2DF26 ,TELEMECANIQUE', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(391, '025  LD-1 Plant', '5797A0271', 'FEROUS METAL;PLATE,AISI 304,420MM', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(392, '025  LD-1 Plant', '0910A1497', 'CT GEAR BOX', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(393, '025  LD-1 Plant', '0486A1346', 'GENL PURPOSE SQIM (75KW, 280S, 1500RPM)', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(394, '025  LD-1 Plant', '5956A3679', 'TARGET SENSOR ,LOGIKA ,TOCB CAMERA BASED', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(395, '025  LD-1 Plant', '5671A0269', 'THRMPCL;CR/AL K TYPE ,MI INSULATED (COMP', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(396, '025  LD-1 Plant', '0390A0028', 'Cera-dian Ceramic Fibre', '025 LDE2                       LD1 DSI elect', 13, 'RLL', '2023-03-31', NULL),
(397, '025  LD-1 Plant', '5890A0539', 'CONTACTOR,32A,2,220V,AUXILIARY,220V,S2,D', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(398, '025  LD-1 Plant', '1123A0527', 'RF TYPE LEVEL SWITCH FOR ESP HOPPER', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(399, '025  LD-1 Plant', '5642A0172', 'INST CBL;1 ,PVC/HRPVC ,PVC ST2 ,GALVANIZ', '025 LDE2                       LD1 DSI elect', 2000, 'M', '2023-03-31', NULL),
(400, '025  LD-1 Plant', '0453A0119', 'SPRING OPERATED CRD FOR POROUS PLUG CAR', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(401, '025  LD-1 Plant', '5872A2578', 'SF6 BREAKER CRADLE  ,ABB ,SF6 BREAKER ,A', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(402, '025  LD-1 Plant', '5542A1941', 'COMMUNICATION ADAPTER ,ALLEN BRADLEY ,PO', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(403, '025  LD-1 Plant', '5900A1006', 'AC MOTR;30KW,415VAC,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(404, '025  LD-1 Plant', '0731A0083', 'MOTORISED ZOOM LENS,8-48 mm,1:1.2', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(405, '025  LD-1 Plant', '5620A1962', 'PLC SPR;COMMUNICATION PROCESSOR,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(406, '025  LD-1 Plant', '5929A0014', 'BRAK MTR;BRAKE MOTORS,100KW,DEMAG', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(407, '025  LD-1 Plant', '1256A1505', 'ARRGT OF INJECTION LANCE D.S.UNIT', '025 LD12                       LD#1 DSI Store', 1, 'SET', '2023-03-31', NULL),
(408, '025  LD-1 Plant', '5956A0244', 'SPARE,INSTRUMENTATION', '025 LDE2                       LD1 DSI elect', 200, 'NOS', '2023-03-31', NULL),
(409, '025  LD-1 Plant', '0565A0317', 'FLOAT PAIR WITH MAGNET,F/MEASURE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(410, '025  LD-1 Plant', '1877A0351', 'CAR/LANDING GATE MAT BYPARTING 52NE7581', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(411, '025  LD-1 Plant', '5890A0715', 'CONTCR;110A,3,110V,POWER,415V,S6,AC', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(412, '025  LD-1 Plant', '1047A2285', 'PSB 200 POWER SUPPLY BOARD 24+110 VDC', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(413, '025  LD-1 Plant', '5620A0533', 'PLC SPR,CP 343-1, SIEMENS,6GK7343-1EX1', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(414, '025  LD-1 Plant', '5526A0018', 'ELECT INSLTR;GLASS,INSULATOR,1100V', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(415, '025  LD-1 Plant', '6125A0057', 'SPD_4-20MA (24V) ,DEHN ,927244 ,', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(416, '025  LD-1 Plant', '5526A0017', 'ELECT INSLTR;GLASS,INSULATOR,1100V', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(417, '025  LD-1 Plant', '1904A0034', 'ZINC OXIDE SURGE ARRESTER 36KV, 20KA', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(418, '025  LD-1 Plant', '1041A5474', 'DI module, 16 channel, 24V DC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(419, '025  LD-1 Plant', '1043A0193', 'INCREMENTAL SHAFT ENCODER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(420, '025  LD-1 Plant', '5520A0435', 'MOTORISED ACTUATOR ,AUMA ,7198907004 ,AU', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(421, '025  LD-1 Plant', '3148A0005', 'DISTANCE SENSOR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(422, '025  LD-1 Plant', '5341A0448', 'MNX225 CONTACTOR ,L&T ,CS 94140B000 ,WIT', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(423, '025  LD-1 Plant', '5496A0397', 'PR TRNTR;HART TYPE,0-250BAR,1:1', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(424, '025  LD-1 Plant', '1586A1065', 'RIO communication adapter', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(425, '025  LD-1 Plant', '5924A0327', 'SPL MOTR;CIRCULATION PUMP ,ABB ,M2BAX112', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(426, '025  LD-1 Plant', '5542A1897', 'DYNAMIC BRAKING RESISTANCE ,SIEMENS ,SIM', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(427, '025  LD-1 Plant', '5490A0478', 'SURGE PROTECTOR ,DEHN ,ELECTRONIC WEIGHI', '025 LDE2                       LD1 DSI elect', 22, 'NOS', '2023-03-31', NULL),
(428, '025  LD-1 Plant', '5620A2545', 'AI VOLTAGE/CURRENT INPUT,8 CHA ,HONEYWEL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(429, '025  LD-1 Plant', '5554A0039', 'LNGT TRF;50 KVA,5% IN 2.5% STEP ,ANAN ,F', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(430, '025  LD-1 Plant', '0546A3234', 'ACS6000 FILTER HOUSE (W/O) WCU', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(431, '025  LD-1 Plant', '5508A0192', 'ENCODER;ABSOLUTE ROTARY ENCODER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(432, '025  LD-1 Plant', '1122A0606', 'Cable reel type power extension board', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(433, '025  LD-1 Plant', '0422A0091', 'Evaporator Motor For 931SEM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(434, '025  LD-1 Plant', '1877A0342', 'VERTICAL LIFT CAGE DOOR-M/C-52NE7581', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(435, '025  LD-1 Plant', '0416A1925', 'Distance Sensor 1000mm Analogue Output', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(436, '025  LD-1 Plant', '5669A1564', 'DOOR LOCK SWITCH ,OTIS ,LIFT ,OTIS ELEVA', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(437, '025  LD-1 Plant', '0207A1850', 'INSULATED STRIPPERS', '025 LDE2                       LD1 DSI elect', 26, 'NOS', '2023-03-31', NULL),
(438, '025  LD-1 Plant', '5475A0201', 'CONT VALV;DN50 ,LINEAR ,SS 316 Reversebl', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(439, '025  LD-1 Plant', '0546A2868', 'ARGONLINE SOLENOID OPERATED BALL VALVE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(440, '025  LD-1 Plant', '5842A0759', 'PIPE;TUBE ,12 MM,SEAMLESS ,6 M,2 MM,ASTM', '025 L1EW                       Electrical Wards', 300, 'M', '2023-03-31', NULL),
(441, '025  LD-1 Plant', '0517A0749', 'Inductive sensor BI40-CP80', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(442, '025  LD-1 Plant', '6183A0050', 'MASTER CONTROLLER;110 VAC,5 A,1-0-1 ,BI', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(443, '025  LD-1 Plant', '5956A0256', 'SPARE,INSTRUMENTATION;VORTEX COOLER', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(444, '025  LD-1 Plant', '5648A0267', '1/3\" VARIFOCAL LENS ,HONEYWELL ,HLD5V50D', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(445, '025  LD-1 Plant', '1043A0471', 'MULTITURN ABSOLUTE ENCODER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(446, '025  LD-1 Plant', '3586TG007', '54       HEAT RADIATION SHIELD', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(447, '025  LD-1 Plant', '6008A0002', 'N/W PASSIVE DEVICE FO CABLE', '025 LDE2                       LD1 DSI elect', 3000, 'M', '2023-03-31', NULL),
(448, '025  LD-1 Plant', '1586A1222', 'RS NETWORK FOR CONTROLNET', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(449, '025  LD-1 Plant', '5189A0082', 'EL T&M INST;ELECTRIC MOTOR CHECKER', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(450, '025  LD-1 Plant', '1103A0267', 'CONTROLLER FOR VIBRATION SENSOR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(451, '025  LD-1 Plant', '0407A1164', 'DIFF- PRESS. TRANSMITTER WITH SEAL', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(452, '025  LD-1 Plant', '0973A0460', 'DUCT, VACUUM,LIFT,9800', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(453, '025  LD-1 Plant', '0758A0670', 'U V FLAME SENSOR', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(454, '025  LD-1 Plant', '0363A0025', 'SOLAR BLINKER TYPE ILLUMINATION LIGHT', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(455, '025  LD-1 Plant', '5650A0144', 'GEARD MOTR;1.1KW,415 VAC +10/-15%', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(456, '025  LD-1 Plant', '0255A1700', '40 to 250A 4P 50KA MCCB', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(457, '025  LD-1 Plant', '5657A0047', 'INDTR;4-20 MA,7 SEGMENT DISPLAY ,PANEL ,', '025 L1EW                       Electrical Wards', 7, 'NOS', '2023-03-31', NULL),
(458, '025  LD-1 Plant', '0475A0241', 'BREAKER INSULATOR', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(459, '025  LD-1 Plant', '5772A0200', 'PUSH BTN;REMOTE PENDENT STATION ,YELLOW', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(460, '025  LD-1 Plant', '5620A2702', 'RTD INPUT MODULE ,SCHNEIDER ,140ARI03010', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(461, '025  LD-1 Plant', '5341A0100', 'RELAY ACCS,CONTACTOR,L&T,CS94136,NO SPEC', '025 L1EW                       Electrical Wards', 9, 'NOS', '2023-03-31', NULL),
(462, '025  LD-1 Plant', '1586A1226', '32-CH DIGITAL OUTPUT MODULE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(463, '025  LD-1 Plant', '5620A3295', 'RSLOGIX 5000 FBD EDITOR ,ALLEN BRADLEY ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(464, '025  LD-1 Plant', '5495A0205', 'CNTRLR;JOYSTICK CONTROLLER ,110 VAC,DIGI', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(465, '025  LD-1 Plant', '0853A0267', '3 TIPS FOR 3TF52 CONTACTOR', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(466, '025  LD-1 Plant', '5620A0858', 'PLC SPR;DIGITAL INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(467, '025  LD-1 Plant', '1156A0088', 'JOYSTICK FOR TILTING UP_DOWN_SWIVEL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(468, '025  LD-1 Plant', '0910A1468', 'BRAKE WHEEL  SP-NM38740JPMV', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(469, '025  LD-1 Plant', '5620A2521', 'ANALOG OUTPUT MODEL ,HONEYWELL ,2MLF-DC4', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(470, '025  LD-1 Plant', '5563A2152', 'INSUL. ELECTRODE SOCKET ,20705327 ,1 ,NA', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(471, '025  LD-1 Plant', '5620A0409', 'PLC SPR,PROFIBUS DP ADAPTER,ABB,64606859', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(472, '025  LD-1 Plant', '0713A0068', 'PULL CORD LIMIT SWITCH', '025 LDE2                       LD1 DSI elect', 55, 'NOS', '2023-03-31', NULL),
(473, '025  LD-1 Plant', '0858A0451', '2T COMPRESSION TYPE LOAD CELL', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(474, '025  LD-1 Plant', '5924A0081', 'SPL MOTR;SCIM,SEW EURO DRIVE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(475, '025  LD-1 Plant', '5620A1466', 'PLC SPR;PROFIBUS FAST CONNECT RS 485 P', '025 LDE2                       LD1 DSI elect', 1000, 'NOS', '2023-03-31', NULL),
(476, '025  LD-1 Plant', '5971A0226', 'GLASS-CARBON FIBER TAPE ,HENKEL LOCTITE', '025 LDE2                       LD1 DSI elect', 90, 'M', '2023-03-31', NULL),
(477, '025  LD-1 Plant', '0485A0396', 'ELECTRONIC OVERCURRENT RELAY EOCR 3DM60', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(478, '025  LD-1 Plant', '5700A0262', 'FIELD SNSR;TRANSMITTER,HONEYWELL,24VDC', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(479, '025  LD-1 Plant', '1586A0215', 'FLEX 120V AC DI MODULE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(480, '025  LD-1 Plant', '1877A1239', 'LOCK ASSLY -(Common New)', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(481, '025  LD-1 Plant', '5620A2703', 'ANALOG OUTPUT MODULE ,SCHNEIDER ,140ACO1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(482, '025  LD-1 Plant', '0742A0345', 'CLX ETHERNET I/P BRIDGE MODULE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(483, '025  LD-1 Plant', '5701A0007', 'ELECT SOCKT/PLG,125A,HDP,5,PLUG & SOCKET', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(484, '025  LD-1 Plant', '1877A1286', 'ELECTRO MAGNET', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(485, '025  LD-1 Plant', '5971A0156', 'BRUSHABLE CERAMIC ,HENKEL LOCTITE ,PC 73', '025 LDE2                       LD1 DSI elect', 10, 'KG', '2023-03-31', NULL),
(486, '025  LD-1 Plant', '0546A1876', 'Relay Module 8 O/p X008R1', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(487, '025  LD-1 Plant', '0546A2946', 'VALVE POSITIONER FEEDBACK TRANSMITTER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(488, '025  LD-1 Plant', '5620A2105', 'PLC SPR;DP/DP COUPLER,SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(489, '025  LD-1 Plant', '5509A0364', 'MCCB;160A,3,690V,50KA,AC,50HZ,2NO+2NC', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(490, '025  LD-1 Plant', '6129A0232', 'DETECTOR CASING ,SMS CONCAST ,855814 ,', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(491, '025  LD-1 Plant', '0742A0564', 'CONTROLNET COMMUNICATION MODULE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(492, '025  LD-1 Plant', '0584A0133', 'FLOW CONTROL VALVE.', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(493, '025  LD-1 Plant', '5620A3242', 'DEVICENET COMMS MODULE ,ALLEN BRADLEY ,1', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(494, '025  LD-1 Plant', '5532A0303', 'GAS ANLYR SPR;Electric gas cooler', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(495, '025  LD-1 Plant', '0565A0324', 'DRIVE BUS BRANCHING NDBU 95', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(496, '025  LD-1 Plant', '0445A0304', 'CABLE DRUM- PLUG SOCKET AND CABLE/E/NBM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(497, '025  LD-1 Plant', '5475A0214', 'CONT VALV;1 IN,LINEAR ,SINGLE ,GLOBE ,PR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(498, '025  LD-1 Plant', '5475A0246', 'CONT VALV;1 IN,LINEAR ,SINGLE ,CAST GLOB', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(499, '025  LD-1 Plant', '5701A0092', 'ELECT SOCKT/PLG;63A,METALLIC,5,PLUG', '025 LDE2                       LD1 DSI elect', 35, 'NOS', '2023-03-31', NULL),
(500, '025  LD-1 Plant', '5219A0667', 'INDUSTRIAL MULTIMETER ,FLUKE 87V ,BEECH', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(501, '025  LD-1 Plant', '1041A2089', 'CONVERTER FOR PC', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(502, '025  LD-1 Plant', '5678A0029', 'ISLTR SGNL;2 CHANNEL PASSIVE ISOLATOR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(503, '025  LD-1 Plant', '0416A2630', 'RELAY O/P MODULE for Analyser PLC', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(504, '025  LD-1 Plant', '0546A2773', 'CC#3SECONDARY COOLING ZONE 2 CONTOLVALVE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(505, '025  LD-1 Plant', '0528A0173', 'Brake BM15HF100Nm440AC-SEW', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(506, '025  LD-1 Plant', '5890A0767', 'CONTCR;25A,3,230V,POWER,230V,AC,50HZ', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(507, '025  LD-1 Plant', '5475A0071', 'CNTRL VALVE;1IN,MODIFIED EQUAL %', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(508, '025  LD-1 Plant', '5620A1754', 'PLC SPR;BUS CONNECTOR,SIEMENS', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(509, '025  LD-1 Plant', '0016A0232', 'Bearings for rope drum Underslung Crane', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(510, '025  LD-1 Plant', '0546A2243', 'ELECTRO PNEUMATIC POSITIONER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(511, '025  LD-1 Plant', '0404A0198', 'LD3 ELECTRO-MECH LINEAR ACTUATOR-P3', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(512, '025  LD-1 Plant', '5956A3994', 'TARGET SENSOR ,LOGIKA TECHNOLOGIES NOS,L', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(513, '025  LD-1 Plant', '5540A0077', 'ELTRNC CARD,DRIVE,PRECHARGING RESISTOR,S', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(514, '025  LD-1 Plant', '1047A1957', 'CT for  ACS 1000 ( VSL ID Fan drive)', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(515, '025  LD-1 Plant', '5532A0331', 'GAS ANLYR SPR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(516, '025  LD-1 Plant', '5090A0029', 'RIPPR SPR', '025 L1EW                       Electrical Wards', 14, 'NOS', '2023-03-31', NULL),
(517, '025  LD-1 Plant', '5959A1296', 'BALL THREADED DRIVE ,HERZOG, GERMANY ,8-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(518, '025  LD-1 Plant', '6098A0290', 'DRV MODL;0.37 KW,SIEMENS ,G120 ,415 V,6S', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(519, '025  LD-1 Plant', '1586A0275', '32 CH.24V dc Output Module', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(520, '025  LD-1 Plant', '1862A0187', 'ACTUATOR FOR DS3 DAMPER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(521, '025  LD-1 Plant', '5845A0117', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(522, '025  LD-1 Plant', '0473A0568', 'SEMI CONDUCTOR FUSE 500 AMPS 660v AC', '025 LDE2                       LD1 DSI elect', 17, 'NOS', '2023-03-31', NULL),
(523, '025  LD-1 Plant', '0936A0502', 'COPPER BUS BAR FLAT', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(524, '025  LD-1 Plant', '0546A0854', 'I/P CONVERTER', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(525, '025  LD-1 Plant', '5620A1661', 'PLC SPR;BUS I/O TERMINAL UNIT,SIEMENS', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(526, '025  LD-1 Plant', '0546A2731', 'Magnetic Flow Meter for EMS Cooling', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(527, '025  LD-1 Plant', '0487A0216', '315mm BRAKE DRUM FOR 225 MOTOR', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(528, '025  LD-1 Plant', '0416A1686', 'IGNITION ELECTRODE PLUG FOR CC M/C.', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(529, '025  LD-1 Plant', '5956A2096', 'LIMIT SWITCH  ,BCH ELECTRIC LTD.  ,GREAS', '025 L1EW                       Electrical Wards', 30, 'NOS', '2023-03-31', NULL),
(530, '025  LD-1 Plant', '5243A5336', 'PLUG-IN CONNECTOR FCE HYD  ,4P M12 GERAD', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(531, '025  LD-1 Plant', '5508A0443', 'ENCODR;ABSOLUTE LINEAR ENCODER ,TR ELECT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(532, '025  LD-1 Plant', '5918A0283', 'SPL MACHINE TOOL,PORTABLE DRILL MACHINE,', '025 L1EW                       Electrical Wards', 2, 'SET', '2023-03-31', NULL),
(533, '025  LD-1 Plant', '1041A4428', 'COMMUNICATION MODULE FOR LF1 SW DRIVE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(534, '025  LD-1 Plant', '1586A1189', 'RIO head Dual Channel, Drops: 31 max', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(535, '025  LD-1 Plant', '1586A1225', '32-CH DIGITAL INPUT MODULE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(536, '025  LD-1 Plant', '2916A0032', 'MMI Display for Common duct O2 analyser', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(537, '025  LD-1 Plant', '1041A2232', 'VM Card for ESP Control Panel', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(538, '025  LD-1 Plant', '0399A0149', 'Braided Hose 1 inch for cables Isotherm', '025 LDE2                       LD1 DSI elect', 200, 'FT', '2023-03-31', NULL),
(539, '025  LD-1 Plant', '1877A1507', 'OSG System Spare parts THYSSEN LIFT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(540, '025  LD-1 Plant', '5717A0527', 'LT CBL;4,6MM2,COPPER,XLPE', '025 LDE2                       LD1 DSI elect', 500, 'M', '2023-03-31', NULL),
(541, '025  LD-1 Plant', '0447A1616', '3C x 70 sq.mm.', '025 LD12                       LD#1 DSI Store', 50, 'M', '2023-03-31', NULL),
(542, '025  LD-1 Plant', '5532A0080', 'GAS ANLYR SPR,PUMP,ADAGE AUTOMATION PVT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(543, '025  LD-1 Plant', '1586A0614', 'CONTROL REDUNDANT BRIDGE MODULE', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(544, '025  LD-1 Plant', '5620A1714', 'PLC SPR;POWER MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(545, '025  LD-1 Plant', '5872A2518', 'CONNECTING ROD FOR 8BD1 PANEL ,SIEMENS ,', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(546, '025  LD-1 Plant', '5700A0881', 'FLD SNSR;MAGNETIC SENSOR ,IFM EFECTOR ,1', '025 L1EW                       Electrical Wards', 21, 'NOS', '2023-03-31', NULL),
(547, '025  LD-1 Plant', '5620A2458', 'SIWAREX U 2 CH ,SIEMENS ,7MH46011BA01 ,L', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(548, '025  LD-1 Plant', '5968A0036', 'SPARE,ELECTRONIC;TETHER ARM FOR ENCODER', '025 LDE2                       LD1 DSI elect', 11, 'SET', '2023-03-31', NULL),
(549, '025  LD-1 Plant', '0910A2032', 'POWER ROCKER ARM ( CARBON BRUSH ASSY. )', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(550, '025  LD-1 Plant', '0546A1224', 'AAFLOAT TYPE LEVEL SWITCH', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(551, '025  LD-1 Plant', '0426A0592', 'Moisture Detector cum Membrane Filter', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(552, '025  LD-1 Plant', '1586A1229', 'COMMUNICATION CONTROL NET MODULE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(553, '025  LD-1 Plant', '0416A1577', 'CONTROLNET ADAPTER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(554, '025  LD-1 Plant', '5900A1322', 'AC MOTR;37KW,415 Â± 10%V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(555, '025  LD-1 Plant', '0416A1687', 'DETECTION ELECTRODE PLUG FOR CC M/C.', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(556, '025  LD-1 Plant', '0853A1382', 'LATCH MECHANISM OF VCU TYPE CONTACTOR', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(557, '025  LD-1 Plant', '5508A0442', 'ENCODR;ABSOLUTE LINEAR ENCODER ,TR ELECT', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(558, '025  LD-1 Plant', '0858A0328', 'WEIGHING INDICATOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(559, '025  LD-1 Plant', '5701A0093', 'ELECT SOCKT/PLG;125A,METALLIC,5,PLUG', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(560, '025  LD-1 Plant', '5508A0140', 'ENCODER;INCREMENTAL ROTARY ENCODER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(561, '025  LD-1 Plant', '0399A0150', 'Braided Hose 1.5 inch for cable Isotherm', '025 LDE2                       LD1 DSI elect', 200, 'FT', '2023-03-31', NULL),
(562, '025  LD-1 Plant', '5918A0421', 'SPL MACHINE TOOL,BRAKE RECTIFIER,SEW EUR', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(563, '025  LD-1 Plant', '1041A3218', 'Interface module IM461 for S7 400 PLC', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(564, '025  LD-1 Plant', '5842A0505', 'PIPE;TUBE,12MM,SEAMLESS,6M,2MM', '025 LDE2                       LD1 DSI elect', 198, 'M', '2023-03-31', NULL),
(565, '025  LD-1 Plant', '0936A0619', 'LOCKING ARRANGEMENT OF PANEL DOOR', '025 L1EW                       Electrical Wards', 35, 'NOS', '2023-03-31', NULL),
(566, '025  LD-1 Plant', '0973A0466', 'DIAPHRAGM , VITON, LIFT CHARGE,98', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(567, '025  LD-1 Plant', '5900A3927', 'AC MOTR;IE2 ,7.5 KW,390 +10%/-10% V,SQUI', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(568, '025  LD-1 Plant', '5700A0265', 'FIELD SNSR;TRANSMITTER,HONEYWELL,24VDC', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(569, '025  LD-1 Plant', '5620A0900', 'PLC SPR;COUNTER MODULE,SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(570, '025  LD-1 Plant', '2297A0222', '30KW,200L4,415V,SIEMENS,SCIM', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(571, '025  LD-1 Plant', '0398A0048', 'TWILIGHT SWITCH/TIME SWITCH', '025 LDE2                       LD1 DSI elect', 21, 'NOS', '2023-03-31', NULL),
(572, '025  LD-1 Plant', '5437A0016', 'SWTCH NTWRK;1000MBPS,8,1000 MBPS FIBER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(573, '025  LD-1 Plant', '0981A0253', 'BEWA TROLLEY', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(574, '025  LD-1 Plant', '0973A0403', 'WINDOW,KIT,FPC,PEA9,MONO', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(575, '025  LD-1 Plant', '5669A0984', 'DOOR MOTOR ,THYSSENKRUPP ,LIFT ,THYSSENK', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(576, '025  LD-1 Plant', '1108A0498', 'NEW FIN FAN SPROCKET', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(577, '025  LD-1 Plant', '5475A0133', 'CTRL VLV;2.5IN,LINEAR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(578, '025  LD-1 Plant', '5900A1922', 'AC MOTR;2.2 KW,415 Â± 10%  V,SQUIRREL CAG', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(579, '025  LD-1 Plant', '5532A0600', 'AUTO CONDENSATE PUMP, 24 VDC ,ADAGE ,GAS', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(580, '025  LD-1 Plant', '5900A1380', 'AC MOTR;18.5KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(581, '025  LD-1 Plant', '1122A0710', '415v AC CONTROL PANEL', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(582, '025  LD-1 Plant', '0486A0914', 'TORQUE APPROACH TABLE MOTOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(583, '025  LD-1 Plant', '0973A0456', 'WINDOW,KIT,FPC,PEA9,GONIO,SP', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(584, '025  LD-1 Plant', '5890A0661', 'CONTACTOR;300A,3,110V,POWER,415V,AC', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(585, '025  LD-1 Plant', '5532A0368', 'GAS ANLYR SPR;SOLENOID VALVE 3/2 WAY', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(586, '025  LD-1 Plant', '5542A0213', 'DRV SPR,PROFIBUS DP MODULE,ABB,RPBA-01,P', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(587, '025  LD-1 Plant', '5509A0090', 'MCCB,630A,3,415V,60KA,AC,50HZ,2NO+2NC,YE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(588, '025  LD-1 Plant', '5532A0295', 'GAS ANLYR SPR', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(589, '025  LD-1 Plant', '5885A0396', 'PROXMTY;INDUCTIVE ,20 ,110 V,IP67 ,GREEN', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(590, '025  LD-1 Plant', '1041A3489', 'I/O Card   /E/NBM', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(591, '025  LD-1 Plant', '5845A0115', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '025 LDE2                       LD1 DSI elect', 200, 'M', '2023-03-31', NULL),
(592, '025  LD-1 Plant', '1041A3284', 'FLEX ANALOG , 12 BIT', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(593, '025  LD-1 Plant', '5620A2761', 'LITHIUM BATTERY ,SIEMENS ,6ES7623-1AE01-', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(594, '025  LD-1 Plant', '0910A2027', 'L T idle wheel assembly', '025 LDE2                       LD1 DSI elect', 3, 'SET', '2023-03-31', NULL),
(595, '025  LD-1 Plant', '5893A0649', 'CONTACT PAD COPPER RING ,SMS DEMAG ,2620', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(596, '025  LD-1 Plant', '0486A1343', 'GENL PURPOSE SQIM (37KW, 225S, 1500RPM)', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(597, '025  LD-1 Plant', '0546A5619', 'CO GAS ANALYZER IR SOURCE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(598, '025  LD-1 Plant', '5620A1818', 'PLC SPR;PROFIBUS CONNECTOR,SIEMENS', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(599, '025  LD-1 Plant', '5542A0753', 'DRV SPR;DIGITAL I/O EXTEN RDIO-01 OPTI', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(600, '025  LD-1 Plant', '0486A0159', '\"UNBALANCE VIBRATOR MOTOR,1.10 KW,415V A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(601, '025  LD-1 Plant', '1304A0554', '(WS-C2960-8TCL)', '025 LD12                       LD#1 DSI Store', 2, 'PCE', '2023-03-31', NULL),
(603, '025  LD-1 Plant', '5623A0902', 'MOTOR CANOPY ,ANY APPROVED ,NOT REQUIRED', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(604, '025  LD-1 Plant', '5523A0094', 'FAN;CABIN,AC,1,230V,WALL,50HZ,400MM,4', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(605, '025  LD-1 Plant', '0853A3013', 'VIBRO FEEDER COIL FOR LF', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(606, '025  LD-1 Plant', '0546A7290', 'electrical pressure regulator', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(607, '025  LD-1 Plant', '5355A0006', '3.3KV ELECT INSULATING MAT,WITH PASTING', '025 LDE2                       LD1 DSI elect', 100, 'M', '2023-03-31', NULL),
(608, '025  LD-1 Plant', '1586A1916', '8 CHANNEL ANALOG I/P MODULE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(609, '025  LD-1 Plant', '1041A2889', 'ANALOG OUT PUT CARD , 8 CH, SM 432', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(610, '025  LD-1 Plant', '5540A1431', 'HYDRAULIC ,CARD HOLDER FOR VT-VSPA1-1-11', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(611, '025  LD-1 Plant', '1724A0003', 'SIEMENS MAKE RELAY(TYPE-3TF2810-OAFO)', '025 LDE2                       LD1 DSI elect', 75, 'NOS', '2023-03-31', NULL),
(612, '025  LD-1 Plant', '2849A0031', 'DVR 9 Channel For CCTV of HBF', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(613, '025  LD-1 Plant', '6028A0184', 'PWR DSTBN PNL;JB FOR TORCH CUTTING MACHI', '025 L1EW                       Electrical Wards', 17, 'NOS', '2023-03-31', NULL),
(614, '025  LD-1 Plant', '5620A0904', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(615, '025  LD-1 Plant', '0942A0096', 'INPUT LINE CHOKE FOR VVF SP 2403', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(616, '025  LD-1 Plant', '0960A0111', 'BATTERY CHARGER FOR O2/CO GAS DETECTOR', '025 LD12                       LD#1 DSI Store', 15, 'NOS', '2023-03-31', NULL),
(617, '025  LD-1 Plant', '5620A0945', 'PLC SPR;CONTROL LOGIX CHASIS', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(618, '025  LD-1 Plant', '5620A2117', 'PLC SPR;POWER MODULE,SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(619, '025  LD-1 Plant', '5900A3910', 'AC MOTR;IE3 ,3.7 KW,500 V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(620, '025  LD-1 Plant', '5542A2387', 'FAN KIT ,RITTAL ,SINAMICS G120 ,SK 3325.', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(621, '025  LD-1 Plant', '5900A1228', 'AC MOTR;30KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(622, '025  LD-1 Plant', '1041A3392', 'CURRENT OUTPUT, 4A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(623, '025  LD-1 Plant', '5620A1821', 'PLC SPR;FLEX 32 TERMINAL BASE FOR DO', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(624, '025  LD-1 Plant', '6088A0126', 'CONTROL RELAY MODULE  ,NOTIFIER  ,1FRM', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(625, '025  LD-1 Plant', '5620A1939', 'PLC SPR;DIGITAL INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(626, '025  LD-1 Plant', '5540A1230', 'ELTNC CARD;FIRE DETECTION SYSTEM', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(627, '025  LD-1 Plant', '0936A0503', 'COPPER BUS BAR FLAT', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(628, '025  LD-1 Plant', '1041A2888', 'ANALOG INPUT CARD -8 CH, SM431, SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(629, '025  LD-1 Plant', '1043A0155', 'LDH CONTROLLER ENCODER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(630, '025  LD-1 Plant', '5246A1206', 'COMPRSR SPR;PRESSURE TRASDUCER', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(631, '025  LD-1 Plant', '5509A0359', 'MCCB;100A,3,690V,50KA,AC,50HZ,2NO+2NC', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(632, '025  LD-1 Plant', '5872A2035', 'S/GR SPR;PENDANT STATION,TELEMECANIQUE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(633, '025  LD-1 Plant', '5900A2024', 'AC MOTR;4.5 KW,415 Â± 10%  V,SLIP RING ,F', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(634, '025  LD-1 Plant', '5620A0506', 'PLC SPR,PLC RACK,SIEMENS,6ES7400 1TA01 0', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(635, '025  LD-1 Plant', '6098A0168', 'DRV MODL;0.37 KW,SIEMENS ,MICROMASTER 44', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(636, '025  LD-1 Plant', '0416A3647', 'Exten Mudle for Relay O/Pof Com Duct Ana', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(637, '025  LD-1 Plant', '5620A1045', 'PLC SPR;DIGITAL OUTPUT MODULE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(638, '025  LD-1 Plant', '5620A1669', 'PLC SPR;EXPANSION BASE 12 SLOT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(639, '025  LD-1 Plant', '0910A1763', 'JUBILEE CLAMP S S ADJUSTABLE TYPE', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(640, '025  LD-1 Plant', '0992A0180', 'PULLEY FOR COMPRESSION MOTOR OF MCC ROOM', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(641, '025  LD-1 Plant', '5700A0897', 'FLD SNSR;POSITION SWITCH ,ALPINE METAL T', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(642, '025  LD-1 Plant', '5262A0049', 'POWER SUPPLY,85-264VAC,12VDC,3A,2938921,', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(643, '025  LD-1 Plant', '6128A0018', 'LARGE DIGITAL INDICATOR ,MASIBUS ,409-4I', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(644, '025  LD-1 Plant', '5918A0797', 'SPL MACHINE TOOL;FERRULE MACHINE', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(645, '025  LD-1 Plant', '6125A0059', 'SPD_RS485 ,DEHN ,927270 ,', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(646, '025  LD-1 Plant', '5555A0021', 'CNV SFTY SW;PULL CORD,10A,415V,2NO+2NC', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(647, '025  LD-1 Plant', '1586A0274', '32 CH.24V dc Input Module', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(648, '025  LD-1 Plant', '0291A2269', 'PNEUMATIC IMPACT SCREW DRIVER', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(649, '025  LD-1 Plant', '0362A1588', 'LARGE SIZE IND. GRADE DISPLAY SYSTEM', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(650, '025  LD-1 Plant', '1041A0822', '4 Channel analog current O/P Card', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(651, '025  LD-1 Plant', '5509A0316', 'MCCB;32A,3,415V,50KA,AC,50HZ,1NO+1NC', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL);
INSERT INTO `t_stock_sap` (`sl`, `plant`, `mtcd`, `material`, `stloc`, `qty`, `unit`, `udt`, `uby`) VALUES
(652, '025  LD-1 Plant', '5890A0575', 'CONTACTOR;250A,3,110V,POWER,415V,S10', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(653, '025  LD-1 Plant', '0530A0121', 'STRIPPEX (SP) IN 500 ML', '025 LDE2                       LD1 DSI elect', 36, 'NOS', '2023-03-31', NULL),
(654, '025  LD-1 Plant', '5620A2334', 'DIGITAL OUTPUT MODULE ,ALLEN BRADLEY ,17', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(655, '025  LD-1 Plant', '0081A0769', 'FLEXIBLE COUPLING FOR CROSS TRANSFER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(656, '025  LD-1 Plant', '6186A0165', 'NW SPARES;NW SPARES RACK MOUNT LIU 12 P', '025 LDE2                       LD1 DSI elect', 14, 'NOS', '2023-03-31', NULL),
(657, '025  LD-1 Plant', '0394A0306', 'SELF FUSING SILICON RUBBER TAPE', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(658, '025  LD-1 Plant', '0088A0204', 'STAINLESS STEEL JUNCTION BOX 400x400x200', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(659, '025  LD-1 Plant', '5048A0012', 'HOOTER;ELECTRONIC,SINGLE,1KM,220VAC', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(660, '025  LD-1 Plant', '0639A1234', 'PRESSURE TRANSDUCER', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(661, '025  LD-1 Plant', '1922A0009', 'FIBRE OPTIC CABLE PATCH CORD', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(662, '025  LD-1 Plant', '5823A5253', 'NMTLC HOSE;GREEN NITRILE RUBBER(C-FREE)', '025 L1EW                       Electrical Wards', 12, 'NOS', '2023-03-31', NULL),
(663, '025  LD-1 Plant', '5620A2701', '32 CHANNEL DIGITAL OUTPUT MODU ,SCHNEIDE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(664, '025  LD-1 Plant', '5700A0885', 'FLD SNSR;MAGNETIC CYLINDER SENSOR ,IFM E', '025 LDE2                       LD1 DSI elect', 28, 'NOS', '2023-03-31', NULL),
(665, '025  LD-1 Plant', '0973A0462', 'TUBE,VACUUM,L1150,PE-X', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(666, '025  LD-1 Plant', '5639A0026', 'FBR OPTIC;62.5/125ÂµM,ST,2', '025 LDE2                       LD1 DSI elect', 3, 'M', '2023-03-31', NULL),
(667, '025  LD-1 Plant', '0758A1297', 'Photoelectric sensors', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(668, '025  LD-1 Plant', '5669A2019', 'BRAKE COIL ,OTIS ,LIFT ,OTIS ELEVATORS ,', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(669, '025  LD-1 Plant', '5620A1754', 'PLC SPR;BUS CONNECTOR,SIEMENS', '025 L1EW                       Electrical Wards', 18, 'NOS', '2023-03-31', NULL),
(670, '025  LD-1 Plant', '5845A0112', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '025 LDE2                       LD1 DSI elect', 200, 'M', '2023-03-31', NULL),
(671, '025  LD-1 Plant', '5540A1028', 'ELTNC CARD;FIRE DETECTION SYSTEM', '025 LDE2                       LD1 DSI elect', 17, 'NOS', '2023-03-31', NULL),
(672, '025  LD-1 Plant', '0546A6029', 'Temperature-Relay TR 250', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(673, '025  LD-1 Plant', '1041A4556', 'CONVERTOR ADAM - 6066', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(674, '025  LD-1 Plant', '1877A0327', 'GOVERNOR- M/C-52NE7581', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(675, '025  LD-1 Plant', '0393A0323', 'LOWER SEPERATOR SHEET FOR LF2 VCB OF LD1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(676, '025  LD-1 Plant', '0546A2866', 'ARGON LINE BALL VALVE 4\"', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(677, '025  LD-1 Plant', '5959A0491', 'FORK LIGHT BARRIER ,HERZOG ,8-6825-35250', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(678, '025  LD-1 Plant', '0082A0378', 'CT Fan Motor Coupling', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(679, '025  LD-1 Plant', '0517A0508', 'PROXIMITY SWITCH', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(680, '025  LD-1 Plant', '1041A1218', 'DI Card 32 Channel', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(681, '025  LD-1 Plant', '1586A0610', '16 CHANNEL 120 VAC FLEX I/P MODULE', '025 LD12                       LD#1 DSI Store', 4, 'NOS', '2023-03-31', NULL),
(682, '025  LD-1 Plant', '0910A2025', 'L T DRIVE WHEEL ASSY.', '025 LDE2                       LD1 DSI elect', 2, 'SET', '2023-03-31', NULL),
(683, '025  LD-1 Plant', '1041A4789', 'Standard Control Cassette, 115V I/O', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(684, '025  LD-1 Plant', '5620A2393', 'DIGITAL INPUT MODULE  ,ALLEN BRADLEY  ,1', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(685, '025  LD-1 Plant', '5620A2393', 'DIGITAL INPUT MODULE  ,ALLEN BRADLEY  ,1', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(686, '025  LD-1 Plant', '0513A0766', 'Phase RotationIndicator,Model: 9040', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(687, '025  LD-1 Plant', '1077A0176', 'Switch Disconnector 125A', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(688, '025  LD-1 Plant', '5542A1910', 'COMMUNICATION MODULE ,ROCKWELL AUTOMATIO', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(689, '025  LD-1 Plant', '0517A0700', 'INDUCTIVE PROXIMITY SWITCH ,M12x1', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(690, '025  LD-1 Plant', '5900A2414', 'AC MOTR;0.37 KW,415 Â± 10%  V,SQUIRREL CA', '025 L1EW                       Electrical Wards', 7, 'NOS', '2023-03-31', NULL),
(691, '025  LD-1 Plant', '1048AA011', '110VACDIGITAL O/P MODULE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(692, '025  LD-1 Plant', '1877A0332', 'GUIDE SHOE(SP TYPE)-CAR/CWT-M/C-52NE7581', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(693, '025  LD-1 Plant', '5089A2785', 'JOYSTICK CONTROLLER MULTI AXIS ,XD2PA22', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(694, '025  LD-1 Plant', '0546A5717', 'FITTING,ANG,D10-R3/8,SERTO', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(695, '025  LD-1 Plant', '2746A0059', '2P K TYPE COMPENSATING ARMORED CABLE', '025 LDE2                       LD1 DSI elect', 256, 'M', '2023-03-31', NULL),
(696, '025  LD-1 Plant', '5620A1053', 'PLC SPR;DIGITAL INPUT MODULE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(697, '025  LD-1 Plant', '0447A1336', '4P x 1.0 sq.mm.', '025 LD12                       LD#1 DSI Store', 100, 'M', '2023-03-31', NULL),
(698, '025  LD-1 Plant', '5542A0211', 'DRV SPR,MAIN CONTACTOR,ABB,AF 460-30-22-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(699, '025  LD-1 Plant', '1039A0101', 'INFRARED BASED REMOTE CONTROL', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(700, '025  LD-1 Plant', '0362A0856', 'WARNING LIGHT WITH INBUILT FLASHER', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(701, '025  LD-1 Plant', '1586A0429', '32 CHANNEL DIGITAL INPUT CARD/E/NBM', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(702, '025  LD-1 Plant', '1041A3262', 'INELTA LVDT  IMA2', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(703, '025  LD-1 Plant', '0527A0094', '\"32 BIT DIGITAL INPUT MODULE ,24VDC,OPTI', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(704, '025  LD-1 Plant', '0244A0497', '240 V DC PNENMATIC TIMER', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(705, '025  LD-1 Plant', '5620A0245', 'PLC SPR,MICRO MEMORY CARD,SIEMENS,6ES795', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(706, '025  LD-1 Plant', '1586A0854', 'Control net Bridge Modulle', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(707, '025  LD-1 Plant', '5607A0034', 'RELAY,NO MODIFIER,PROTECTION OF LV MOTOR', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(708, '025  LD-1 Plant', '5885A0527', 'PROXMTY;MAGNETIC REED SWITCH ,75 MM,10 T', '025 LDE2                       LD1 DSI elect', 5, 'PCE', '2023-03-31', NULL),
(709, '025  LD-1 Plant', '0546A3718', '3/2 way Solenoid Valve N/O FUNCTION.', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(710, '025  LD-1 Plant', '5900A3379', 'AC MOTR;IE2 ,1.1 KW,415 +10%,-15% V,SQUI', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(711, '025  LD-1 Plant', '5607A0666', 'RELAY;ELECTROMECHANICAL,CONTROL CIRCUIT', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(712, '025  LD-1 Plant', '1678A0121', 'POwer Supply MINI-100-240AC/10-15DC/2', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(713, '025  LD-1 Plant', '5872A2059', 'S/GR SPR;CLOSING/TRIPPING COIL,SIEMENS', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(714, '025  LD-1 Plant', '5607A0190', 'RELAY,NO MODIFIER,POWER APPLICATION,99%,', '025 LDE2                       LD1 DSI elect', 120, 'NOS', '2023-03-31', NULL),
(715, '025  LD-1 Plant', '0940A0057', 'FESTOONING CABLE,6X3CX1KV,CU,EPR,CSP SH', '025 L1EW                       Electrical Wards', 230, 'M', '2023-03-31', NULL),
(716, '025  LD-1 Plant', '6049A0118', 'SPL INST;3 WAY MANIFOLD VALVE ,INSTRUMEN', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(717, '025  LD-1 Plant', '5493A0153', 'FLOW MTR;5BAR,WATER/LIQUID', '025 LDE2                       LD1 DSI elect', 1, 'LPM', '2023-03-31', NULL),
(718, '025  LD-1 Plant', '1586A0276', 'ETHERNET COMMUNICATION ADOPTER', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(719, '025  LD-1 Plant', '5540A1029', 'ELTNC CARD;FIRE DETECTION SYSTEM', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(720, '025  LD-1 Plant', '1041A5502', 'COUNTER MODULE FM 450', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(721, '025  LD-1 Plant', '5532A0277', 'GAS ANLYR SPR;Equal Tee 1/2\" OD SS-316\"', '025 LDE2                       LD1 DSI elect', 51, 'NOS', '2023-03-31', NULL),
(722, '025  LD-1 Plant', '5540A1370', 'HYDRAULIC ,CARD HOLDER ,REXROTH ,VT3002-', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(723, '025  LD-1 Plant', '5532A0367', 'GAS ANLYR SPR;SOLENOID VALVE 2/2 WAY', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(724, '025  LD-1 Plant', '5540A1432', 'HYDRAULIC ,AMPLIFIER CARD PL 6 ,BOSCH RE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(725, '025  LD-1 Plant', '5532A0290', 'GAS ANLYR SPR;Flow monitor 10- 100 LPH', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(726, '025  LD-1 Plant', '0546A2908', 'SECONDARY COOLING , CC#3 DN 65 VALVE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(727, '025  LD-1 Plant', '5563A2154', 'INSULATION CU TUBE CLAMP ,20706127 ,1 ,N', '025 LDE2                       LD1 DSI elect', 16, 'NOS', '2023-03-31', NULL),
(728, '025  LD-1 Plant', '5523A0073', 'FAN;AIR CURTAIN,AC,SINGLE,220V,WALL', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(729, '025  LD-1 Plant', '5542A3319', 'POWERMODUL IGBT PIRED 400A/120 ,SCHNEIDE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(730, '025  LD-1 Plant', '0599A0187', 'COMPLETE SET OF TIGHTENING BOLT', '025 LDE2                       LD1 DSI elect', 4, 'SET', '2023-03-31', NULL),
(731, '025  LD-1 Plant', '5924A0378', 'SPL MOTR;0.23 KW 2800 RPM UNBLCE MOTOR ,', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(732, '025  LD-1 Plant', '0255A0051', '\"MCB,32A,O/L 22-32A,415V WITH CURRENT LI', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(733, '025  LD-1 Plant', '6122A0082', 'CABLE ACCESSORIES;450  V,TYPE:U1K16  ,TE', '025 L1EW                       Electrical Wards', 1000, 'NOS', '2023-03-31', NULL),
(734, '025  LD-1 Plant', '6088A0002', 'FDA SPARE;ELECTRONIC HOOTER,SAFEWAY', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(735, '025  LD-1 Plant', '5532A0087', 'GAS ANLYR SPR,FILTER,SIEMENS,SHS ACCESSO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(736, '025  LD-1 Plant', '5881A0007', 'GAS DTCTR;MULTI GAS DETECTOR,PORTABLE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(737, '025  LD-1 Plant', '0256A1267', 'MPCB, 80-100 A , 3RV10 41 4MA10', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(738, '025  LD-1 Plant', '5959A1279', 'PEDESTAL BEARING ,HERZOG, GERMANY ,8-311', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(739, '025  LD-1 Plant', '5506A0112', 'CTRL TRF;10 KVA,THREE ,DRY ,415 V,0-415', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(740, '025  LD-1 Plant', '1041A2727', 'CURRENT TRANS. ES 500-9661 390A', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(741, '025  LD-1 Plant', '1586A1337', 'PF 700 VECTOR CONTROL 115V AC KIT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(742, '025  LD-1 Plant', '5900A1146', 'AC MOTR;11KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(743, '025  LD-1 Plant', '5341A0453', 'RELAY BASE ,PHOENIX ,PLC-BSC-120UC/21HC/', '025 L1EW                       Electrical Wards', 50, 'PCE', '2023-03-31', NULL),
(744, '025  LD-1 Plant', '6088A0091', 'OPTICAL SMOKE DETECTOR&BASE ,SYSTEM SENS', '025 L1EW                       Electrical Wards', 57, 'SET', '2023-03-31', NULL),
(745, '025  LD-1 Plant', '5507A0178', 'BRAK;08E ,ELECTROMAGNETIC ,POWER FAIL TO', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(746, '025  LD-1 Plant', '5900A3980', 'AC MOTR;IE3 ,0.75 KW,415 Â± 10% V,SQUIRRE', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(747, '025  LD-1 Plant', '5243A4010', 'PLUG IN CONNECTOR ,R900021267 ,REXROTH ,', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(748, '025  LD-1 Plant', '1156A0089', 'JOYSTICK LEFT AND RIGHT FOR RAKING M/C', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(749, '025  LD-1 Plant', '0853G0081', 'COVER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(750, '025  LD-1 Plant', '5620A2042', 'PLC SPR;PLC RACK,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(751, '025  LD-1 Plant', '5819A0139', 'MOBILE MAINTENANCE TROLLEY ,TROLLEY LADD', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(752, '025  LD-1 Plant', '0256A1317', '4 WAY DD LOADLINE DB', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(753, '025  LD-1 Plant', '6186A0092', 'NW SPARES;24 PORT FIBER LIU RACK MOUNT', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(754, '025  LD-1 Plant', '0255A0573', 'MCCB 252-630 A FF/3P/R630/LSIG', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(755, '025  LD-1 Plant', '1041A3501', 'CRMB E- ER1 RACK', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(756, '025  LD-1 Plant', '5669A1154', 'EMERGENCY LIGHT ,OTIS ,LIFT ,OTIS ,NAA41', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(757, '025  LD-1 Plant', '5872A0464', 'SW GR&CB SPR,SEL-LOK PIN SPS UNBRAKO,JOS', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(758, '025  LD-1 Plant', '5669A1943', 'KIT ELECTROMAGNET/RET.CAM,R.H. ,OTIS ,LI', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(759, '025  LD-1 Plant', '5739A0048', 'TIMER;ON DELAY TIMER ,110 VAC,BCH ,110 V', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(760, '025  LD-1 Plant', '5523A0145', 'FAN;HEAVY DUTY AXIAL FLOW FAN ,AC ,SINGL', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(761, '025  LD-1 Plant', '5964A0171', 'PNL;WELDING MACHINE SAFETY PANEL ,450X44', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(762, '025  LD-1 Plant', '1041A4585', 'I/P MODULE', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(763, '025  LD-1 Plant', '5355A0003', '11KV ELECT INSULATING MAT', '025 LDE2                       LD1 DSI elect', 6, 'RLL', '2023-03-31', NULL),
(764, '025  LD-1 Plant', '5900A1298', 'AC MOTR;11KW,415 Â± 10%V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(765, '025  LD-1 Plant', '5620A0220', 'PLC SPR,TERMINAL BASE,ROCKWELL AUTOMATIO', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(766, '025  LD-1 Plant', '1041A2097', 'FEPROM 1MB', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(767, '025  LD-1 Plant', '5701A0095', 'ELECT SOCKT/PLG;32A,METALLIC,5,SOCKET', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(768, '025  LD-1 Plant', '0546A1875', 'Digital I/p Module XI 16EI', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(769, '025  LD-1 Plant', '0362A1092', 'LARGE SIZE PROCESS INDICATOR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(770, '025  LD-1 Plant', '5900A0894', 'AC MOTR;1.1KW,415+10% -15%VAC', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(771, '025  LD-1 Plant', '5620A2400', 'FLEX 110V AC 16 CHANNEL DO ,ALLEN BRADLE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(772, '025  LD-1 Plant', '1048A0999', '85-265 VAC POWER SUPPLY', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(773, '025  LD-1 Plant', '0517A0667', 'INDUCTIVE SENSOR NI 30U -M30', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(774, '025  LD-1 Plant', '5089A3461', 'JOYSTICK CONTROLLER MULTI AXIS ,XD2PA24', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(775, '025  LD-1 Plant', '5560A0016', 'PCB RLY;24V,POWER PCB RELAY,DC,1,1,5', '025 L1EW                       Electrical Wards', 300, 'NOS', '2023-03-31', NULL),
(776, '025  LD-1 Plant', '1041A1004', 'CP 5611 CARD FOR PCI SLOT', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(777, '025  LD-1 Plant', '5620A2566', 'FLEX HIGH SPEED COUNTER MODULE ,HONEYWEL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(778, '025  LD-1 Plant', '0390A0031', 'Ceramic Flexible Sleeving', '025 LDE2                       LD1 DSI elect', 3, 'ROL', '2023-03-31', NULL),
(779, '025  LD-1 Plant', '5506A0047', 'TRNSFMR CTRL,2KVA,1,DRY,415V,240V,F,50HZ', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(780, '025  LD-1 Plant', '0380A0287', 'MAGNETIC LIMIT SWITCH,LATCHING', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(781, '025  LD-1 Plant', '5620A1227', 'PLC SPR;ETHERNET MODULE,HONEYWELL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(782, '025  LD-1 Plant', '5669A1661', '41 TYPE LOCK RH[NOA6694B2] ,OTIS ,LIFT ,', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(783, '025  LD-1 Plant', '5900A3424', 'AC MOTR;IE2 ,0.25 KW,415 Â± 10% V,SQUIRRE', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(784, '025  LD-1 Plant', '0546A3230', 'AIR FILTER REGULATOR FOR SAMSON VALVE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(785, '025  LD-1 Plant', '5411A0031', 'PADLOCK;7 ,BRASS ,3 NOS,COMMON LOCK KEY', '025 LDE2                       LD1 DSI elect', 60, 'NOS', '2023-03-31', NULL),
(786, '025  LD-1 Plant', '1047A1793', 'D2D160-BE02-12 FAN FOR ABB DRIVE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(787, '025  LD-1 Plant', '5942A0720', '5/2 WAY PNEUMATIC SOLENOID VLV ,BOPEL005', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(788, '025  LD-1 Plant', '0587A0474', 'P.O.C.V.FOR CC3 TURRET&LID SYS.', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(789, '025  LD-1 Plant', '5872A1985', 'S/GR SPR;CLOSING/TRIPPING COIL,SIEMENS', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(790, '025  LD-1 Plant', '5341A0091', 'RELAY ACCS,CONTACTOR,L&T,CS94137,NO SPEC', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(791, '025  LD-1 Plant', '0397A0426', 'CONTACT PAD COPPER SEALING RING OF LHF1', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(792, '025  LD-1 Plant', '1047A0648', 'OPTIC FIBRE CABLE, 10MTR -OFC CABLE', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(793, '025  LD-1 Plant', '5959A0479', 'FIBER OPTIC CONDUCTOR ,HERZOG ,8-6847-33', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(794, '025  LD-1 Plant', '0565A0328', 'BASIC UNIT FOR SIGUARD SAFETY COMBI.', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(795, '025  LD-1 Plant', '1048A0330', 'MOD ANALOG INPUT 12 BIT 8 POINT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(796, '025  LD-1 Plant', '1586A1534', 'STRATIX 2000 UNMANAGED ETHERNET SWITCH', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(797, '025  LD-1 Plant', '5623A0309', 'MOTOR&ACCES,STAR POINT GROUNDING ASSY,PR', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(798, '025  LD-1 Plant', '0255A0045', 'MOULDED CASE CIRCUIT BREAKER', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(799, '025  LD-1 Plant', '0394A0168', 'RACAME TAPE', '025 LDE2                       LD1 DSI elect', 200, 'RLL', '2023-03-31', NULL),
(800, '025  LD-1 Plant', '5048A0011', 'HOOTER;ELECTRONIC,SINGLE,1KM,220VAC', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(801, '025  LD-1 Plant', '5571A0005', 'UPS SPR;COMMUNICATION INTERFACE BOARD', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(802, '025  LD-1 Plant', '5571A0005', 'UPS SPR;COMMUNICATION INTERFACE BOARD', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(803, '025  LD-1 Plant', '6026A0011', 'FLOW ELEMENT;ORIFICE PLATE,MS,200MM', '025 LDE2                       LD1 DSI elect', 2, 'M3H', '2023-03-31', NULL),
(804, '025  LD-1 Plant', '5544A5991', 'BOLT;HEX HEAD ,20 MM,130 MM,70 ,SS304 ,I', '025 LDE2                       LD1 DSI elect', 150, 'NOS', '2023-03-31', NULL),
(805, '025  LD-1 Plant', '0485A0740', '110v AC/DC, 1PDT RELAYS (RAIL MOUNTED)', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(806, '025  LD-1 Plant', '5620A0112', 'PLC SPR,DC INPUT MODULE,SCHNEIDER,140DDO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(807, '025  LD-1 Plant', '0088A0591', 'JB FOR TROLLEY', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(808, '025  LD-1 Plant', '5620A1103', 'PLC SPR;DIGITAL INPUT MODULE,ROCKWELL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(809, '025  LD-1 Plant', '1157A0082', '3 COLOUR POWER INDICATION LIGHT', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(810, '025  LD-1 Plant', '5521A0376', 'BRAKE SHOE WITH LINER ,SIBRE ,SIBRE ,BRA', '025 L1EW                       Electrical Wards', 1, 'SET', '2023-03-31', NULL),
(811, '025  LD-1 Plant', '5047A0088', 'LOCO ELECT,PART,RELAY BOARD WITH OMRON R', '025 LDE2                       LD1 DSI elect', 24, 'NOS', '2023-03-31', NULL),
(812, '025  LD-1 Plant', '5669A0397', 'LFT SPR;ENCO_H88-30C-1024DO_METRONIX_', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(813, '025  LD-1 Plant', '0486A2751', '3 PHASE  INDUCTION MOTOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(814, '025  LD-1 Plant', '5544A5992', 'BOLT;HEX HEAD ,20 MM,125 MM,70 ,SS304 ,I', '025 LDE2                       LD1 DSI elect', 150, 'NOS', '2023-03-31', NULL),
(815, '025  LD-1 Plant', '0853A2211', '400AMPS KNIFE SWITCH,DPST TYPE,250V', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(816, '025  LD-1 Plant', '5842A0757', 'PIPE;TUBE ,6 MM,SEAMLESS ,6 M,1 MM,ASTM', '025 L1EW                       Electrical Wards', 198, 'M', '2023-03-31', NULL),
(817, '025  LD-1 Plant', '5532A0295', 'GAS ANLYR SPR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(818, '025  LD-1 Plant', '5508A0564', 'ENCODR;NUHYDRO ,NH/AS-D50-30 ,ENCODER CO', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(819, '025  LD-1 Plant', '5623A0901', 'MOTOR CANOPY ,ANY APPROVED ,NOT REQUIRED', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(820, '025  LD-1 Plant', '5537A0230', 'BATERY;NI-CD ,CRANE REMOTE CONTROL ,7.2', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(821, '025  LD-1 Plant', '5620A1314', 'PLC SPR;DIGITAL INPUT MODULE,HONEYWELL', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(822, '025  LD-1 Plant', '5701A0096', 'ELECT SOCKT/PLG;63A,METALLIC,5,SOCKET', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(823, '025  LD-1 Plant', '1041A2873', 'LEM-320 Loop Expander Module', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(824, '025  LD-1 Plant', '0362A1141', 'LARGE SIZE DOUBLE SIDED LED DISPLAY', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(825, '025  LD-1 Plant', '5701A0088', 'ELECT SOCKT/PLG;32A,METALLIC,5,PLUG', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(826, '025  LD-1 Plant', '1586A0615', '4 CH.,PULSE FLEX CTR', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(827, '025  LD-1 Plant', '1586A0819', 'BATTERY FOR CONTROL LOGIX', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(828, '025  LD-1 Plant', '5900A1329', 'AC MOTR;11KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(829, '025  LD-1 Plant', '5620A1822', 'PLC SPR;FLEX TERMINAL BASE', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(830, '025  LD-1 Plant', '5859A0517', 'INSLTG MTR;INSULATING PLATE ,ASBESTOS GL', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(831, '025  LD-1 Plant', '0367A0249', 'MULTI INPUT ALARM ANNUNCIATION PANEL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(832, '025  LD-1 Plant', '5509A0454', 'MCCB;63A,3,690V,50KA,AC,50HZ,1NO+1NC,NO', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(833, '025  LD-1 Plant', '5900A1231', 'AC MOTR;7.5KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(834, '025  LD-1 Plant', '5900A1942', 'AC MOTR;0.75 KW,415 Â± 10% V,SQUIRREL CAG', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(835, '025  LD-1 Plant', '5845A0109', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '025 LDE2                       LD1 DSI elect', 200, 'M', '2023-03-31', NULL),
(836, '025  LD-1 Plant', '0858A0400', 'FLEX LOCK MOUNTING FOR  5 TON LOADCELL', '025 LDE1                       Trafic storeElec', 4, 'NOS', '2023-03-31', NULL),
(837, '025  LD-1 Plant', '5620A1844', 'PLC SPR;CPU MAIN BASE NR 8 SLOT', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(838, '025  LD-1 Plant', '5620A1446', 'PLC SPR;ANALOG OUTPUT MODULE,PHOENIX', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(839, '025  LD-1 Plant', '1877A0318', 'GOV ROPE,DIA-10MM,NO-1-M/C-52NE7581', '025 L1EW                       Electrical Wards', 118, 'M', '2023-03-31', NULL),
(840, '025  LD-1 Plant', '5842A0753', 'PIPE;TUBE ,6 MM,SEAMLESS ,6 M,1 MM,ASTM', '025 L1EW                       Electrical Wards', 250, 'M', '2023-03-31', NULL),
(841, '025  LD-1 Plant', '0958A2258', 'Ribbon connector for ABB ACS 800 Drive', '025 LD12                       LD#1 DSI Store', 4, 'SET', '2023-03-31', NULL),
(842, '025  LD-1 Plant', '5701A0142', 'EL SKT/PLG;20A,METAL CLAD,2,SOCKET,230V', '025 L1EW                       Electrical Wards', 250, 'NOS', '2023-03-31', NULL),
(843, '025  LD-1 Plant', '0470A0612', 'Pad lockable Emergency switch', '025 L1EW                       Electrical Wards', 22, 'NOS', '2023-03-31', NULL),
(844, '025  LD-1 Plant', '5924A0537', 'SPL MOTR;0.37 KW MOTOR ,AMIAD WATER SYST', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(845, '025  LD-1 Plant', '5620A2210', 'PLC SPR;INTERFACE MODULE,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(846, '025  LD-1 Plant', '5620A2214', 'PLC SPR;INTERFACE MODULE,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(847, '025  LD-1 Plant', '5411A0012', 'PADLOCK;7,BRASS,2', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(848, '025  LD-1 Plant', '5669A0051', 'LFT SPR;PCB MCU MOTHERBOARD TIC V', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(849, '025  LD-1 Plant', '0767A0241', 'CGL#2 - FURNACE STEERING POWER SUPPLY', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(850, '025  LD-1 Plant', '0447A1223', '1C x 70 sq.mm.', '025 LD12                       LD#1 DSI Store', 70, 'M', '2023-03-31', NULL),
(851, '025  LD-1 Plant', '1586A0499', 'Power supply for main base', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(852, '025  LD-1 Plant', '5900A3889', 'AC MOTR;IE2 ,2.25 KW,415 Â± 10% V,SQUIRRE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(853, '025  LD-1 Plant', '5620A1773', 'PLC SPR;DIGITAL OUTPUT MODULE,HONEYWELL', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(854, '025  LD-1 Plant', '5859A0307', 'INSULATING MATL;HEAT SHRINKABLE TUBE', '025 L1EW                       Electrical Wards', 200, 'M', '2023-03-31', NULL),
(855, '025  LD-1 Plant', '5262A0054', 'POWER SUPPLY,400-500VAC,24VDC,40A,293864', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(856, '025  LD-1 Plant', '0758A0258', 'SENSOR TROUBE FOR ZERO SPEED SWITCH', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(857, '025  LD-1 Plant', '5959A1863', 'ROTATING DRIVE ,HARZOG ,8-2786-333650-0', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(858, '025  LD-1 Plant', '5620A2351', '24 V DC 16 CHANNEL DI ,ALLEN BRADLEY ,17', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(859, '025  LD-1 Plant', '5620A1688', 'PLC SPR;S7-300, DIGITAL OUTPUT SM322', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(860, '025  LD-1 Plant', '5669A1367', 'MAIN TRANSFORMER ,OTIS ,LIFT ,OTIS ,NYMO', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(861, '025  LD-1 Plant', '0255A0639', 'CRANK HANDLE FOR S6 MCCB', '025 LD12                       LD#1 DSI Store', 9, 'NOS', '2023-03-31', NULL),
(862, '025  LD-1 Plant', '0877A1423', 'SEMICONDUCTOR FUSE 40 AMPS', '025 L1EW                       Electrical Wards', 30, 'NOS', '2023-03-31', NULL),
(863, '025  LD-1 Plant', '5900A1841', 'AC MOTR;5.5 KW,415 Â± 10% V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(864, '025  LD-1 Plant', '5900A1947', 'AC MOTR;0.37 KW,415 Â± 10% V,SQUIRREL CAG', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(865, '025  LD-1 Plant', '0783A0089', 'DUEL OUTPUT VOLTAGE SIGNAL ISOLATOR', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(866, '025  LD-1 Plant', '0936A0751', 'LINE CHOKE 12 AMPS 2.6 MILLI HENRY', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(867, '025  LD-1 Plant', '5669A1263', 'BRAKE SHOE LINER 27BT ,OTIS ,LIFT ,OTIS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(868, '025  LD-1 Plant', '5620A1533', 'PLC SPR;POWER SUPPLY,HONEYWELL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(869, '025  LD-1 Plant', '5620A0109', 'PLC SPR,32-CH DIGITAL INPUT MODULE,SCHNE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(870, '025  LD-1 Plant', '5669A1983', 'COPPER CONTACT BIG ,OTIS ,LIFT ,OTIS ELE', '025 L1EW                       Electrical Wards', 14, 'NOS', '2023-03-31', NULL),
(871, '025  LD-1 Plant', '5761A0209', 'EL BOX;JUNCTION BOX ,220 V,WALL ,OUTDOOR', '025 LDE2                       LD1 DSI elect', 4, 'PCE', '2023-03-31', NULL),
(872, '025  LD-1 Plant', '5872A2922', 'FEED-THROUGH MODULAR TB ,PHOENIX ,MCC ,3', '025 L1EW                       Electrical Wards', 1000, 'NOS', '2023-03-31', NULL),
(873, '025  LD-1 Plant', '5127A0012', 'CONSTRCN PLATE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(874, '025  LD-1 Plant', '5859A0120', 'INSULATING MATL,SHEET,FIBRE INSULATOR,73', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(875, '025  LD-1 Plant', '5900A2103', 'AC MOTR;5.5 KW,415 Â± 10% V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(876, '025  LD-1 Plant', '5956A0680', 'INST SPR;Contact Block for temp S 2 Co', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(877, '025  LD-1 Plant', '5956A0930', 'INST SPR;CONTACT BLOCK FOR TEMP B 2 COR', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(878, '025  LD-1 Plant', '0367A0202', 'HOOTER FOR HT PANEL. (AUH-1122)', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(879, '025  LD-1 Plant', '5900A3877', 'AC MOTR;IE2 ,1.5 KW,415 Â± 10% V,SQUIRREL', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(880, '025  LD-1 Plant', '1041A5088', 'LOOP DRIVER CARD', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(881, '025  LD-1 Plant', '0486A1533', 'SM422  DIGITAL OUTPUT MODULE, 32 D0', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(882, '025  LD-1 Plant', '1041A5004', 'DCCT Feedback Card', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(883, '025  LD-1 Plant', '5544A3661', 'BOLT;HEX HEAD ,20  MM,150  MM,70 ,SS304', '025 LDE2                       LD1 DSI elect', 75, 'NOS', '2023-03-31', NULL),
(884, '025  LD-1 Plant', '0447A1154', '1C x 16 sq.mm. EPR CSP', '025 LD12                       LD#1 DSI Store', 200, 'M', '2023-03-31', NULL),
(885, '025  LD-1 Plant', '0546A1086', 'EET ELECT.POWER & INSTRUMENTS', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(886, '025  LD-1 Plant', '1586A0495', 'HMI Interface Module', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(887, '025  LD-1 Plant', '0416A1396', 'MILL DUTY HOUSING', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(888, '025  LD-1 Plant', '5752A1596', 'DRIVE GEAR ,202-GR-13031 ,ARMSEL ,NO SPE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(889, '025  LD-1 Plant', '0479A0392', 'LF#1.TRANSFORMER CURRENT TRANSDUCER', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(890, '025  LD-1 Plant', '0546A1328', 'U.V. FLAME DETECTOR', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(891, '025  LD-1 Plant', '5557A0037', 'BRDG RCTFR;DIODE BRIDGE RECTIFIER,TWO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(892, '025  LD-1 Plant', '5669A0641', 'SPP W ON DELAY_VCT-D2_MINILEC ,THYSSENKR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(893, '025  LD-1 Plant', '5542A0275', 'DRV SPR;COOLING FAN,ABB,R2E225-BD92-12', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(894, '025  LD-1 Plant', '5607A0918', 'RELAY;SAFETY RELAY ,GAS RECOVERY PLC ,SI', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(895, '025  LD-1 Plant', '0395A0016', 'FLAMEPROOF VINYLSTER RESIN CAST COVERS', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(896, '025  LD-1 Plant', '1041A0936', 'Profibus Repeater', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(897, '025  LD-1 Plant', '0367A0114', 'INDUSTRIAL SIREN', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(898, '025  LD-1 Plant', '1586A0493', 'CPU Main Base', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(899, '025  LD-1 Plant', '5959A1860', 'SAMPLE SUPPORT ,HARZOG ,5-2171-282018-1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(900, '025  LD-1 Plant', '5965A2685', 'PROXIMITY SWITCH ,8-6841-335700-1 ,HERZO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(901, '025  LD-1 Plant', '5872A0465', 'SW GR&CB SPR,COTTER PIN,JOSLYN HI VOLTAG', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(902, '025  LD-1 Plant', '5607A0685', 'RELAY;PLUGGABLE MINIATURE RELAY', '025 L1EW                       Electrical Wards', 100, 'NOS', '2023-03-31', NULL),
(903, '025  LD-1 Plant', '1031A0148', 'M12x160mm SS HEX HEAD BOLT WITH NUTS', '025 LDE2                       LD1 DSI elect', 70, 'SET', '2023-03-31', NULL),
(904, '025  LD-1 Plant', '0426A0556', 'ALE CONNECTOR for GAS ANALYSER', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(905, '025  LD-1 Plant', '0546A5718', 'NIPPLE,HOSE,DE,D10,BRASS', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(906, '025  LD-1 Plant', '0475A0221', 'MIGI RAPPER  COIL 220V', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(907, '025  LD-1 Plant', '1041A0881', '16 CHANNEL VARIOFACE WITH OMRON RELAY .', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(908, '025  LD-1 Plant', '0853A1787', 'AUX.CONT. BLOCK DC', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(909, '025  LD-1 Plant', '1041A5508', 'Power Supply Module', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(910, '025  LD-1 Plant', '5959A0490', 'POSITION SWITCH ,HERZOG ,8-5527-352524-3', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(911, '025  LD-1 Plant', '1041A2149', 'RDCO-01C DDCS Communication Board', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(912, '025  LD-1 Plant', '1040A0581', 'PANEL DOOR LOCKING HANDLE', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(913, '025  LD-1 Plant', '5835A0296', 'CHEM SLD;DM WATER PRODUCTION,7,8%,25Â°C', '025 LDE2                       LD1 DSI elect', 50, 'L', '2023-03-31', NULL),
(914, '025  LD-1 Plant', '5872A1181', 'SW GR&CB SPR,ZERO SPEED SWITCH,JAYASHREE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(915, '025  LD-1 Plant', '0256A2002', 'Bezel for Draw out L&T ACB', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(916, '025  LD-1 Plant', '0486A3794', '15 KW 160MLE4 1450 RPM B35 MOTOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(917, '025  LD-1 Plant', '5965A2681', 'CLAMPING JAW FOR PARA GRIPER ,7-7030-283', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(918, '025  LD-1 Plant', '5671A0272', 'THRMPCL;K SIMPLEX ,SS 316 ,0.5 ,10000 MM', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(919, '025  LD-1 Plant', '0853A2159', 'SET OF FIXED & MOVING CONTACT', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(920, '025  LD-1 Plant', '5859A0515', 'INSLTG MTR;INSULATION SLEEVE ,SYNDANYIO', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(921, '025  LD-1 Plant', '1586A1868', 'FRONT CONNECTOR, 48 PIN', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(922, '025  LD-1 Plant', '0546A1752', 'Flow Monitor Range : 50 -500 LPH', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(923, '025  LD-1 Plant', '1586A1228', 'RG-6 CABLE (SOFT PER ROLL), ASM BII 003', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(924, '025  LD-1 Plant', '5900A2862', 'AC MOTR;IE2 ,0.75 KW,415 Â± 10% V,SQUIRRE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(925, '025  LD-1 Plant', '5859A0516', 'INSLTG MTR;INSULATING PLATE ,ASBESTOS GL', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(926, '025  LD-1 Plant', '5700A0882', 'FLD SNSR;INDUCTIVE PROXIMITY SENSOR ,IFM', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(927, '025  LD-1 Plant', '5508A0565', 'ENCODR;NUHYDRO ,NH/AS-D32-25 ,ENCODER CO', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(928, '025  LD-1 Plant', '3513A0027', 'M10x50MM S.S HEX HEAD BOLT WITH NUT', '025 LDE2                       LD1 DSI elect', 200, 'NOS', '2023-03-31', NULL),
(929, '025  LD-1 Plant', '5506A0189', 'CTRL TRF;3 KVA,SINGLE ,DRY ,415 V,220 VA', '025 L1EW                       Electrical Wards', 2, 'PCE', '2023-03-31', NULL),
(930, '025  LD-1 Plant', '5620A1967', 'PLC SPR;DIN RAIL,SIEMENS', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(931, '025  LD-1 Plant', '0393A0295', 'LF FIXED JAW INSULATOR', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(932, '025  LD-1 Plant', '0517A0587', 'PROXIMITY SWITCH', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(933, '025  LD-1 Plant', '5669A1984', 'BRADED LID FOR 6830 RELAY ,OTIS ,LIFT ,O', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(934, '025  LD-1 Plant', '5243A6549', 'CABLE FOR CLAMP ON FLOW METER ,OP-87274', '025 LDE2                       LD1 DSI elect', 5, 'SET', '2023-03-31', NULL),
(935, '025  LD-1 Plant', '5669A1562', 'DOOR GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVAT', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(936, '025  LD-1 Plant', '0877A0463', '16 A  HRC FUSE BS TYPE', '025 LD12                       LD#1 DSI Store', 400, 'NOS', '2023-03-31', NULL),
(937, '025  LD-1 Plant', '5700A0896', 'FLD SNSR;POSITION SWITCH ,ALPINE METAL T', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(938, '025  LD-1 Plant', '5766A0570', 'FIBERGLASS STEP STAND 4 FT ,FY 8004 ,SUM', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(939, '025  LD-1 Plant', '5900A2073', 'AC MOTR;1.5 KW,415 Â± 10%  V,SQUIRREL CAG', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(940, '025  LD-1 Plant', '0546A3188', 'PRESSURE TRANSMITTER,CAPACTIVEMEASURING', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(941, '025  LD-1 Plant', '5700A0749', 'FLD SNSR;INDUCTIVE PROXIMITY SWITCH ,JAY', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(942, '025  LD-1 Plant', '1889A1051', 'BRAKE RECTIFIER: BME 1.5', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(943, '025  LD-1 Plant', '5669A1528', 'GOV ROPE (8MM) ,OTIS ,LIFT ,OTIS ELEVATO', '025 LDE2                       LD1 DSI elect', 80, 'M', '2023-03-31', NULL),
(944, '025  LD-1 Plant', '5872A2265', 'TERMINAL BLOCK ,PHOENIX CONTACT ,PLC PAN', '025 LDE2                       LD1 DSI elect', 1900, 'NOS', '2023-03-31', NULL),
(945, '025  LD-1 Plant', '5552A0372', 'MPCB;90A,3,690V,45KW,50HZ,70-90A,0,50Â°C', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(946, '025  LD-1 Plant', '5900Y0299', 'AC MOTR;IE3 ,0.37 KW,415 Â± 10% V,SQUIRRE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(947, '025  LD-1 Plant', '5620A1051', 'PLC SPR;REDUNDANCY MODULE,ALLEN BRADLEY', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(948, '025  LD-1 Plant', '5542A0925', 'DRIV SPR;BOP 2,SIEMENS,G120', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(949, '025  LD-1 Plant', '5620A1795', 'PLC SPR;RELAY BOARD,BOOST,RP110AO81COM', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(950, '025  LD-1 Plant', '0773A0335', '2/2 sol valve for Oxygen Analyser', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(951, '025  LD-1 Plant', '0546A1332', 'CABLE JOINTING LUX CELOX LANCE', '025 LDE2                       LD1 DSI elect', 4750, 'NOS', '2023-03-31', NULL),
(952, '025  LD-1 Plant', '1048A0977', '24V DC 10A POWER SUPPLY UNIT', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(953, '025  LD-1 Plant', '5871A1841', 'STRAIGHT CONNECTOR ,STRAIGHT ,12X12 MM,M', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(954, '025  LD-1 Plant', '5956A0241', 'SPARE,INSTRUMENTATION', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(955, '025  LD-1 Plant', '5620A1822', 'PLC SPR;FLEX TERMINAL BASE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(956, '025  LD-1 Plant', '5900A1084', 'AC MOTR;7.5KW,415 Â± 10%V,SQUIRREL CAGE', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(957, '025  LD-1 Plant', '1041A2200', 'CBP2 BOARD', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(958, '025  LD-1 Plant', '0517A0998', 'Induction Type Proximity Switch', '025 L1EW                       Electrical Wards', 20, 'NOS', '2023-03-31', NULL),
(959, '025  LD-1 Plant', '5610A0084', 'CNVTR ELNC;AC TO DC ,110 TO 220 VAC,2 A,', '025 L1EW                       Electrical Wards', 10, 'PCE', '2023-03-31', NULL),
(960, '025  LD-1 Plant', '1041A4523', 'RAD DO4 IFS for combined car', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(961, '025  LD-1 Plant', '0380A0629', 'ELECTRONIC SPEED SWITCH', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(962, '025  LD-1 Plant', '5885A0036', 'PROXIMITY,INDUCTIVE SWITCH,5MM,24/240V,I', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(963, '025  LD-1 Plant', '5872A1984', 'S/GR SPR;SPRING CHARGING MOTOR,SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(964, '025  LD-1 Plant', '5965A2682', 'CLAMPING JAW PNEUMATIC TRANSPO ,7-9251-1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(965, '025  LD-1 Plant', '0877A0131', 'HRC FUSE,500A', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(966, '025  LD-1 Plant', '5713A0373', 'LTNG FTG&ACC;EMERGENCY LIGHT,PROLITE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(967, '025  LD-1 Plant', '1042A0931', 'SILICON OIL TUBE', '025 LD12                       LD#1 DSI Store', 4, 'NOS', '2023-03-31', NULL),
(968, '025  LD-1 Plant', '1377A0061', 'HEX BOLT OD- 3/4 INCH', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(969, '025  LD-1 Plant', '5521A0377', 'THRUSTER ,SIBRE ,SIBRE ,TE 315 EHT Brake', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(970, '025  LD-1 Plant', '5900A3991', 'AC MOTR;IE2 ,0.55 KW,415 Â± 10% V,SQUIRRE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(971, '025  LD-1 Plant', '0530A0401', 'POWERSEAL SLEEVE', '025 LDE2                       LD1 DSI elect', 50, 'M', '2023-03-31', NULL),
(972, '025  LD-1 Plant', '5669A1476', 'THIMBLE W/KIT ,OTIS ,LIFT ,OTIS ,NXTAAG5', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(973, '025  LD-1 Plant', '5620A0070', 'PLC SPR,VARIOFACE RELAY MODULE,PHOENIX C', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(974, '025  LD-1 Plant', '5607A0863', 'RELAY;PLUGGABLE MINIATURE RELAY', '025 LDE2                       LD1 DSI elect', 150, 'NOS', '2023-03-31', NULL),
(975, '025  LD-1 Plant', '1041A2087', 'UNION', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(976, '025  LD-1 Plant', '5701A0141', 'EL SKT/PLG;20A,METAL CLAD,3', '025 L1EW                       Electrical Wards', 185, 'NOS', '2023-03-31', NULL);
INSERT INTO `t_stock_sap` (`sl`, `plant`, `mtcd`, `material`, `stloc`, `qty`, `unit`, `udt`, `uby`) VALUES
(977, '025  LD-1 Plant', '0973A0461', 'PUMPING, D16/23 X 1000', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(978, '025  LD-1 Plant', '5885A0389', 'PROXMTY;INDUCTIVE ,15 MM,110 V,IP67 ,GRE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(979, '025  LD-1 Plant', '5669A0414', 'LFT SPR;BRAKE RESISTNCE ASY 50 OHM 4KW', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(980, '025  LD-1 Plant', '5669A2465', 'BATTERY 12V 18AH  ,THYSSENKRUPP ,LIFT ,T', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(981, '025  LD-1 Plant', '0485A0469', 'DULE 1 CHANGE OVER', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(982, '025  LD-1 Plant', '6093A0023', 'LUMR;TUBE T8,13W,AC,140 - 270V,NO,YES', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(983, '025  LD-1 Plant', '0416A1862', 'LPC-DX50 FRONT PROTECTION COVER', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(984, '025  LD-1 Plant', '5532A0262', 'GAS ANLYR SPR;HEATING CARTRIDGE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(985, '025  LD-1 Plant', '3586TG007', '46       PIN', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(986, '025  LD-1 Plant', '0877A1585', 'SEMICON FUSE 500A SITOR', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(987, '025  LD-1 Plant', '5669A1142', 'TENSION WHEEL ,OTIS ,LIFT ,OTIS ,ANXMO95', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(988, '025  LD-1 Plant', '0426A0565', 'Moisture detector for gas analyser', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(989, '025  LD-1 Plant', '5704A0048', 'C/O SW;MANUAL  ,160  A,4  ,415  V,NO SPE', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(990, '025  LD-1 Plant', '5885A0395', 'PROXMTY;INDUCTIVE ,12 MM,110 V,IP67 ,GRE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(991, '025  LD-1 Plant', '1924A0128', 'LHF W.C CONDUCTING HOSE SS WATER PLUG', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(992, '025  LD-1 Plant', '5620A1466', 'PLC SPR;PROFIBUS FAST CONNECT RS 485 P', '025 L1EW                       Electrical Wards', 200, 'NOS', '2023-03-31', NULL),
(993, '025  LD-1 Plant', '5620A2222', 'PLC SPR;ALLEN BRADLEY,1747-CP3,0', '025 LDE2                       LD1 DSI elect', 1, 'SET', '2023-03-31', NULL),
(994, '025  LD-1 Plant', '5798A2386', 'METAL MAGIC STEEL PUTTY ,HENKEL ,LOCTITE', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(995, '025  LD-1 Plant', '0508A0022', 'ZERO SPEED SWITCH', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(996, '025  LD-1 Plant', '5859A0514', 'INSLTG MTR;INSULATION SLEEVE ,SYNDANYIO', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(997, '025  LD-1 Plant', '5959A0477', 'SHORT STROKE CYLINDER ,HERZOG ,8-2766-34', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(998, '025  LD-1 Plant', '5965A2683', 'CLAMPING JAW PNEUMATIC TRANSPO ,7-9251-2', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(999, '025  LD-1 Plant', '0122A0533', 'AUTOGLOW PHOTOLUMINSCENT TAPE', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(1000, '025  LD-1 Plant', '0546A0960', 'ON LINE PRESSURE REGULATOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1001, '025  LD-1 Plant', '5872A2006', 'S/GR SPR;64 PIN PLUG ASSEMBLY,SIEMENS', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1002, '025  LD-1 Plant', '5701A0189', 'EL SKT/PLG;100 A,METALLIC ,5 ,PLUG ,230', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1003, '025  LD-1 Plant', '0393A0430', 'LHF ARM PEDESTAL CYLINDRICAL INSULATOR', '025 L1EW                       Electrical Wards', 12, 'NOS', '2023-03-31', NULL),
(1004, '025  LD-1 Plant', '6024A0039', 'ALUMINIUM FOIL TAPE ,50 MM,ALUMINIUM FOI', '025 LDE2                       LD1 DSI elect', 150, 'RLL', '2023-03-31', NULL),
(1005, '025  LD-1 Plant', '1041A2085', '90 DEG. BENT WAVEGUIDE', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1006, '025  LD-1 Plant', '0546A5259', 'FITTING,STR,D10-G1/4,PA', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1007, '025  LD-1 Plant', '1877A0333', 'GUIDE SHOE GIBS(SP TYPE)-M/C-52NE7581', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1008, '025  LD-1 Plant', '5900A1370', 'AC MOTR;5.5KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1009, '025  LD-1 Plant', '5872A2435', 'THERMOSTAT ,APT CONTROL & APPLIANCES ,VC', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1010, '025  LD-1 Plant', '0078A0414', 'TAPARIA SPANNER SET', '025 LDE2                       LD1 DSI elect', 11, 'SET', '2023-03-31', NULL),
(1011, '025  LD-1 Plant', '0984A0104', 'ADAM 4050 RADIO MODEM MODULE', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(1012, '025  LD-1 Plant', '0255A1540', 'ROTARY HADLE WITH ROD(320-400amps)', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(1013, '025  LD-1 Plant', '5968A0023', 'SPARE,ELECTRONIC;HDMI Cable', '025 LDE2                       LD1 DSI elect', 10, 'M', '2023-03-31', NULL),
(1014, '025  LD-1 Plant', '5900A1882', 'AC MOTR;7.5 KW,415 Â± 10% V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1015, '025  LD-1 Plant', '5859A0329', 'INSTNG MATL;CABLE SLEEVE', '025 LDE2                       LD1 DSI elect', 5, '20M', '2023-03-31', NULL),
(1016, '025  LD-1 Plant', '0758A1228', 'Inductive sensor IGC250', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(1017, '025  LD-1 Plant', '5900A1652', 'AC MOTR;3 KW,415 Â± 10%  V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1018, '025  LD-1 Plant', '5701A0188', 'EL SKT/PLG;20 A,METALLIC ,5 ,PLUG ,230 V', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1019, '025  LD-1 Plant', '5968A0037', 'SPARE,ELECTRONIC;BUSH FOR ENCODER', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1020, '025  LD-1 Plant', '5871A1828', 'MALE CONNECTOR ,MALE CONNECTOR ,1/2 INCH', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1021, '025  LD-1 Plant', '1041A5000', '6 way pulse Amplifier card', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1022, '025  LD-1 Plant', '5772A0069', 'PUSH BTTN;ILLUMINATED,GREEN,SCHNEIDER', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1023, '025  LD-1 Plant', '5772A0068', 'PUSH BTTN;ILLUMINATED,RED,SCHNEIDER', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1024, '025  LD-1 Plant', '5900A1989', 'AC MOTR;5.5 KW,415 Â± 10% V,SQUIRREL CAGE', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1025, '025  LD-1 Plant', '0426A0617', 'Silicone tube for gas analyser 14/10', '025 LDE2                       LD1 DSI elect', 30, 'M', '2023-03-31', NULL),
(1026, '025  LD-1 Plant', '5900A1942', 'AC MOTR;0.75 KW,415 Â± 10% V,SQUIRREL CAG', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1027, '025  LD-1 Plant', '5684A0190', 'SPL LGHT;RECHARGEABLE EMERGENCY LAMP ,YE', '025 L1EW                       Electrical Wards', 10, 'PCE', '2023-03-31', NULL),
(1028, '025  LD-1 Plant', '5427A0035', 'PNL MTR;CURRENT  ,0-1  A,AMMETER  ,48 X', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1029, '025  LD-1 Plant', '5713A0247', 'LTNG FT&ACC SPR,INDICATION LIGHT,BALAJI', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(1030, '025  LD-1 Plant', '0416A2378', 'POWER SUPPLY 220V AC WITH DISPLAY', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1031, '025  LD-1 Plant', '5872A2337', 'TERMINAL BLOCK ,PHOENIX CONTACT ,ELECTRI', '025 L1EW                       Electrical Wards', 1000, 'NOS', '2023-03-31', NULL),
(1032, '025  LD-1 Plant', '6186A0160', 'NW SPARES;LC-SC FO PATCH CORD OS2, SM 3M', '025 LDE2                       LD1 DSI elect', 11, 'NOS', '2023-03-31', NULL),
(1033, '025  LD-1 Plant', '6026A0010', 'FLOW ELEMENT;ORIFICE PLATE,MS,80NB', '025 LDE2                       LD1 DSI elect', 2, 'M3H', '2023-03-31', NULL),
(1034, '025  LD-1 Plant', '5885A0388', 'PROXMTY;INDUCTIVE ,12 MM,110 V,IP67 ,GRE', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1035, '025  LD-1 Plant', '5669A1414', 'R CAM COIL ,OTIS ,LIFT ,OTIS ,LO222T1 ,P', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1036, '025  LD-1 Plant', '0517C0025', 'PROXIMITY SWITCH', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1037, '025  LD-1 Plant', '0393A0429', 'LHF ARM PEDESTAL MIDDLE BUSH INSULATOR', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1038, '025  LD-1 Plant', '0362A0553', 'ELECTRONICIGNITORS FOR SON70W/MHN-TD70W', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1039, '025  LD-1 Plant', '5620A1382', 'PLC SPR;SPLITTER,QUANTUM,MA0186100,0', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1040, '025  LD-1 Plant', '5772A0185', 'PUSH BTN;PUSH BUTTON ACTUATOR ,GREEN ,TE', '025 L1EW                       Electrical Wards', 60, 'NOS', '2023-03-31', NULL),
(1041, '025  LD-1 Plant', '5713A0246', 'LTNG FT&ACC SPR,INDICATION LIGHT,BALAJI', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(1042, '025  LD-1 Plant', '5844A0139', 'PLUG SPARE ,BCH ,HANDLE ASSEMBLY FOR 125', '025 LD12                       LD#1 DSI Store', 20, 'NOS', '2023-03-31', NULL),
(1043, '025  LD-1 Plant', '5956A1463', 'INST SPR;SIMPLEX RTD WITH THERMOWELL', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1044, '025  LD-1 Plant', '5607A0697', 'RELAY;PLUGGABLE MINIATURE RELAY', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1045, '025  LD-1 Plant', '0517A0668', 'CONNECTION CABLE M 12 x 1 female', '025 LDE2                       LD1 DSI elect', 14, 'NOS', '2023-03-31', NULL),
(1046, '025  LD-1 Plant', '5575A0029', 'RCBO;63A,4,415V,300MA,C,50HZ,50Â°C,AC', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1047, '025  LD-1 Plant', '0984A0131', 'AXIOM MAKE 10 AMP POWER SUPPLY', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1048, '025  LD-1 Plant', '5262A0309', 'POW SPLY;110-230 VAC,+/-24 VDC,20 A,PHOE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1049, '025  LD-1 Plant', '1043A0350', 'ENCODER', '025 L1EW                       Electrical Wards', 1, 'PCE', '2023-03-31', NULL),
(1050, '025  LD-1 Plant', '5766A0335', 'SPL TOOLS;FINGERSAVER STANDARD TOOL', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1051, '025  LD-1 Plant', '5669A1409', 'PIT SWITCH ,OTIS ,LIFT ,OTIS ,NAA635A2 ,', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1052, '025  LD-1 Plant', '5012A4411', 'ELEMENT FILTER ASSY NOS,GT4E ,PARKER ,EX', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1053, '025  LD-1 Plant', '5607A1290', 'RELAY;ELECTROMECHANICAL ,GENERAL PURPOSE', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(1054, '025  LD-1 Plant', '6021A0070', 'EL TSTG INST;PHASE SEQUENCE INDICATOR ,E', '025 LD12                       LD#1 DSI Store', 10, 'NOS', '2023-03-31', NULL),
(1055, '025  LD-1 Plant', '6186A0013', 'NW SPARES;STP PATCH CORD 2 MTR CAT6  ,NA', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1056, '025  LD-1 Plant', '5778A2798', 'WATER FILTER ,PSMC/FLT/011 ,PRECISION SP', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(1057, '025  LD-1 Plant', '5669A1297', 'COPPER CONTACT ,OTIS ,LIFT ,OTIS ,NX150Y', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1058, '025  LD-1 Plant', '0291A2267', 'FORK SPANNER SW 56', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1059, '025  LD-1 Plant', '5669A1310', 'CARBON CONTACT(BIG) ,OTIS ,LIFT ,OTIS ,N', '025 L1EW                       Electrical Wards', 15, 'NOS', '2023-03-31', NULL),
(1060, '025  LD-1 Plant', '6045A0191', 'SPL CBL;PROXIMITY SWITCH CABLE ,IFM ELEC', '025 L1EW                       Electrical Wards', 14, 'NOS', '2023-03-31', NULL),
(1061, '025  LD-1 Plant', '0902A0256', 'INSTRUMENT COOLING FAN', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1062, '025  LD-1 Plant', '5669A2002', 'PUSH BUTTON ,OTIS ,LIFT ,OTIS ELEVATORS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1063, '025  LD-1 Plant', '5620A0869', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1064, '025  LD-1 Plant', '5739A0074', 'TIMER;ON DELAY TIMER ,24-240 VAC/DC,ABB', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1065, '025  LD-1 Plant', '5309A0450', 'COMTR SPR;WIRELESS KEY & MOUSE,LOGITECH', '025 LD12                       LD#1 DSI Store', 10, 'NOS', '2023-03-31', NULL),
(1066, '025  LD-1 Plant', '5959A1864', 'PROXIMITY SWITCH ,HARZOG ,8-6841-332414-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1067, '025  LD-1 Plant', '0486A0505', '5.5 KW MOTOR FOR SHUTTLE CONVEYOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1068, '025  LD-1 Plant', '5620A1818', 'PLC SPR;PROFIBUS CONNECTOR,SIEMENS', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(1069, '025  LD-1 Plant', '5544A2517', 'BOLT ;HEX HEAD,20MM,110MM,80,SS304', '025 LDE2                       LD1 DSI elect', 35, 'SET', '2023-03-31', NULL),
(1070, '025  LD-1 Plant', '5900A1199', 'AC MOTR;7.5KW,415 Â± 10%V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1071, '025  LD-1 Plant', '0758A1227', 'Inductive sensor IFT216', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(1072, '025  LD-1 Plant', '0449A0973', '2C x 1.5 SQ.MM.', '025 LD12                       LD#1 DSI Store', 400, 'M', '2023-03-31', NULL),
(1073, '025  LD-1 Plant', '1586A0839', '3 LINE GROUND TERMINAL BASE SCREW CLAMP', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1074, '025  LD-1 Plant', '1756A0006', 'TIMER RELAY 2/T', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1075, '025  LD-1 Plant', '0958A1274', 'HEAVY DUTY THREADED COUPLING, MIL-C-5015', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1076, '025  LD-1 Plant', '0546A3493', 'ADJUSTABLE DEAD BAND PR.SWITCH', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1077, '025  LD-1 Plant', '0546A3494', 'ADJUSTABLE DEAD BAND PR.SWITCH', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1078, '025  LD-1 Plant', '0546A3495', 'ADJUSTABLE DEAD BAND PR.SWITCH', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1079, '025  LD-1 Plant', '0517A0422', 'CABLE CONNECTOR ,M12 CONNECTOR', '025 LDE2                       LD1 DSI elect', 12, 'NOS', '2023-03-31', NULL),
(1080, '025  LD-1 Plant', '5620A2707', 'CONTROLNET TAPS ,SCHNEIDER ,MA0185100 ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1081, '025  LD-1 Plant', '0426A0563', 'Silicone tube for gas analyser', '025 LD12                       LD#1 DSI Store', 25, 'NOS', '2023-03-31', NULL),
(1082, '025  LD-1 Plant', '1877A0343', 'GOVERNOR TENSION FRAME/PULLY-M/C52NE7581', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1083, '025  LD-1 Plant', '5620A1824', 'PLC SPR;POWER SUPPLY,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1084, '025  LD-1 Plant', '0537A1877', 'O RING NITRILE GRADE INSULATION RUBBER', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(1085, '025  LD-1 Plant', '0958A2508', 'REXROTH CARD HOLDER OF LF1 ET PANEL', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1086, '025  LD-1 Plant', '0902A0255', 'INSTRUMENT COOLING FAN', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1087, '025  LD-1 Plant', '5540A0983', 'ELTNC CARD;DISPLAY,PROCESSOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1088, '025  LD-1 Plant', '5715A0537', 'UNIREX N3 ,MOBIL/SHELL ,UNIREX N3 ,16 KG', '025 LDE2                       LD1 DSI elect', 18, 'KG', '2023-03-31', NULL),
(1089, '025  LD-1 Plant', '0758A1229', 'Inductive sensor IGT219', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(1090, '025  LD-1 Plant', '5631A0004', 'INST CLNG FAN,AC,230V,250MM,50 HZ,115 W', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(1091, '025  LD-1 Plant', '1877A1308', 'COIL CY1', '025 L1EW                       Electrical Wards', 11, 'NOS', '2023-03-31', NULL),
(1092, '025  LD-1 Plant', '5607A1193', 'RELAY;AUXILIARY RELAY ,AUXILIARY PROTECT', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1093, '025  LD-1 Plant', '0358A0032', 'PLUG FOR ELECT. POWER', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(1094, '025  LD-1 Plant', '0291A2270', 'HEXAGON SOCKET WRENCH K 32-46', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1095, '025  LD-1 Plant', '5620A0071', 'PLC SPR,VARIOFACE RELAY MODULE,PHOENIX C', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(1096, '025  LD-1 Plant', '0486A2469', 'MOTOR, 7.5KW,132M,415V,3-PH,50HZ,4-POLE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1097, '025  LD-1 Plant', '5542A1154', 'DRIV SPR;COOLING FAN,EBMPAPAST', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1098, '025  LD-1 Plant', '5648A0199', 'CAMRA&ACC;CAMERA HOUSING,BOSCH', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1099, '025  LD-1 Plant', '5506A0115', 'CTRL TRF;3 KVA,SINGLE ,DRY ,415 V,110 V,', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1100, '025  LD-1 Plant', '0853A2691', 'Sidelock device VCS/VCB frontlock plate', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(1101, '025  LD-1 Plant', '5794A0469', 'CBL SKT;LONG BARREL FLAT ,95 MM2,COPPER', '025 LDE2                       LD1 DSI elect', 100, 'PCE', '2023-03-31', NULL),
(1102, '025  LD-1 Plant', '5900A1902', 'AC MOTR;0.37 KW,415 Â± 10% V,SQUIRREL CAG', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1103, '025  LD-1 Plant', '5956A0990', 'INST SPR;M12 CABLE CONNECTOR', '025 L1EW                       Electrical Wards', 12, 'NOS', '2023-03-31', NULL),
(1104, '025  LD-1 Plant', '5620A2708', 'CONNECTOR ,SCHNEIDER ,MA0329001 ,', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1105, '025  LD-1 Plant', '0255A1204', 'MCCB FOR MILL MCC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1106, '025  LD-1 Plant', '5669A1977', 'J1 PANEL ,OTIS ,LIFT ,OTIS ELEVATORS ,A6', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1107, '025  LD-1 Plant', '0958A1280', 'HEAVY DUTY THREADED COUPLING MIL-C-5015', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1108, '025  LD-1 Plant', '6045A0629', 'SPL CBL;PROXIMITY CONNECTION CABLE ,TELE', '025 L1EW                       Electrical Wards', 8, 'PCE', '2023-03-31', NULL),
(1109, '025  LD-1 Plant', '5620A2236', 'PLC SPR;LITHIUM BATTERY,ALLEN BRADLEY', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1110, '025  LD-1 Plant', '1041A3387', '16 Point INPUT-32PTS.(SINK/SOURCE TYPE)', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1111, '025  LD-1 Plant', '0473A0385', 'CRMB-E-60tCRANE-SEMICONDUCTOR FUSE 100A', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1112, '025  LD-1 Plant', '0546A2776', 'IGNITION TRANSFORMER ,HOT AIR GENERATOR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1113, '025  LD-1 Plant', '5639A0022', 'OPTC FBR CBL;12MM,OPTIC FIBRE(PLASTIC)', '025 LDE2                       LD1 DSI elect', 1, 'M', '2023-03-31', NULL),
(1114, '025  LD-1 Plant', '5700A0057', 'FIELD SNSR,RF BASED CAPACITANCE TYPE,EIP', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1115, '025  LD-1 Plant', '0798A0407', 'BACK TO BACK LAYOUT PRINTING B/W', '025 L190                       Vessel Elect str', 5000, 'NOS', '2023-03-31', NULL),
(1116, '025  LD-1 Plant', '1877A1450', 'CAR TOPJUNCTION BOX FOR TKEI LIFT', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1117, '025  LD-1 Plant', '1041A4790', 'PowerFlex 700 I/O Option, 115V AC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1118, '025  LD-1 Plant', '5506A0211', 'CTRL TRF;0.25 KVA,THREE ,DRY ,415-0-440', '025 L1EW                       Electrical Wards', 4, 'PCE', '2023-03-31', NULL),
(1119, '025  LD-1 Plant', '5872A1849', 'SW GR&CB SPR;FUSE TERMINAL,PHOENIX', '025 L1EW                       Electrical Wards', 150, 'NOS', '2023-03-31', NULL),
(1120, '025  LD-1 Plant', '0244A0587', 'DS SOCKET 16AMPS', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1121, '025  LD-1 Plant', '5811A3266', 'M16 X 60 HEX FIT BOLT ,LD#1 ,CRANE ,AS P', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1122, '025  LD-1 Plant', '5620A1821', 'PLC SPR;FLEX 32 TERMINAL BASE FOR DO', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1123, '025  LD-1 Plant', '1877A1307', 'COIL  CX1', '025 L1EW                       Electrical Wards', 9, 'NOS', '2023-03-31', NULL),
(1124, '025  LD-1 Plant', '5958A0027', 'CONT BLK;ELECTRICAL PANEL,TEKNIC,1,NO', '025 LDE2                       LD1 DSI elect', 170, 'NOS', '2023-03-31', NULL),
(1125, '025  LD-1 Plant', '5872A0474', 'SW GR&CB SPR,CONTACT KIT,BCH,CONTACTOR,S', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1126, '025  LD-1 Plant', '5506A0186', 'CTRL TRF;0.25 KVA,THREE ,DRY ,415 V,220/', '025 L1EW                       Electrical Wards', 4, 'PCE', '2023-03-31', NULL),
(1127, '025  LD-1 Plant', '5748A0609', 'FUSE;HRC,400A,500V,120KA,AC', '025 L1EW                       Electrical Wards', 14, 'NOS', '2023-03-31', NULL),
(1128, '025  LD-1 Plant', '1098A0036', 'Link Chain Grab Bucket roller assembly', '025 LDE2                       LD1 DSI elect', 200, 'FT', '2023-03-31', NULL),
(1129, '025  LD-1 Plant', '5559A0002', 'THERMWEL;TAPERED SHANK,SILLICON CARBIDE', '025 L1EW                       Electrical Wards', 10, 'MM', '2023-03-31', NULL),
(1130, '025  LD-1 Plant', '5921A0147', 'HOSE,MTLLC,AIR/STEAM/WATER,SS304,14BAR,C', '025 LD12                       LD#1 DSI Store', 4, 'NOS', '2023-03-31', NULL),
(1131, '025  LD-1 Plant', '0390A0029', 'ceramic tape', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1132, '025  LD-1 Plant', '5668A0352', 'MESRG ISNT;M/C VIBRATION MONITOR ,VIBRAT', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1133, '025  LD-1 Plant', '1256A2196', 'PULLEY FOR FILTRATE PUMP FOR WWTP', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(1134, '025  LD-1 Plant', '5885A0326', 'PROXMTY;INDUCTIVE,4MM,10-30V,IP68', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1135, '025  LD-1 Plant', '0513A0778', 'Non-Contact Digital Tachometer', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1136, '025  LD-1 Plant', '5872A2059', 'S/GR SPR;CLOSING/TRIPPING COIL,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1137, '025  LD-1 Plant', '0380A0275', 'LIMIT SWITCH', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1138, '025  LD-1 Plant', '1877A1553', 'Buffer Spring', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1139, '025  LD-1 Plant', '5490A0241', 'WEGHNG M/C ACC', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(1140, '025  LD-1 Plant', '1586A1338', '20B-ENC-1', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1141, '025  LD-1 Plant', '5959A1857', 'PNEUMATIC CYLINDER ,HARZOG ,8-2772-34444', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1142, '025  LD-1 Plant', '5540A0984', 'ELTNC CARD;DISPLAY,LED DISPLAY CARD', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(1143, '025  LD-1 Plant', '0081A0662', 'COUPLING COVER FOR SHIFTING MOTOR', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1144, '025  LD-1 Plant', '5794A0310', 'CBL SCKT;PIN,2.5MM2,COPPER,STRAIGHT', '025 L1EW                       Electrical Wards', 8750, 'NOS', '2023-03-31', NULL),
(1145, '025  LD-1 Plant', '5859A0330', 'INSTNG MATL;CABLE SLEEVE', '025 LDE2                       LD1 DSI elect', 5, '20M', '2023-03-31', NULL),
(1146, '025  LD-1 Plant', '5900A2145', 'AC MOTR;0.37 KW,415 Â± 10% V,SQUIRREL CAG', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1147, '025  LD-1 Plant', '0255A0819', '63A MCCB for Tilt PDB', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1148, '025  LD-1 Plant', '0486A3885', 'Squirrel Cage Induction Motor 0.75KW', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1149, '025  LD-1 Plant', '5872A0488', 'SW GR&CB SPR,SOCKET,SIEMENS,ASSEMBLY,SIE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1150, '025  LD-1 Plant', '6028A0234', 'PWR DSTBN PNL;TERMINAL BLOCK ,ELMEX ,CST', '025 L1EW                       Electrical Wards', 500, 'NOS', '2023-03-31', NULL),
(1151, '025  LD-1 Plant', '6186A0297', 'NW SPARES;12 PORT LOADED FIBER LIU RACK', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1152, '025  LD-1 Plant', '5900A0991', 'AC MOTR;2.2KW,415V,SQUIRREL CAGE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1153, '025  LD-1 Plant', '0244A0586', 'DS PLUG 16AMPS', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1154, '025  LD-1 Plant', '5958A0028', 'CONT BLK;ELECTRICAL PANEL,TELEMECANIQUE', '025 LDE2                       LD1 DSI elect', 150, 'NOS', '2023-03-31', NULL),
(1155, '025  LD-1 Plant', '0291A6854', 'Auto Glow Signage 3M 120 micron', '025 LDE2                       LD1 DSI elect', 52, 'FT2', '2023-03-31', NULL),
(1156, '025  LD-1 Plant', '5794A0309', 'CBL SCKT;PIN,1.5MM2,COPPER,STRAIGHT', '025 L1EW                       Electrical Wards', 8300, 'NOS', '2023-03-31', NULL),
(1157, '025  LD-1 Plant', '1615A0422', 'RG-6 Co-axial Cable.(Video Cable)', '025 LDE2                       LD1 DSI elect', 500, 'M', '2023-03-31', NULL),
(1158, '025  LD-1 Plant', '5958A0029', 'CONT BLK;ELECTRICAL PANEL,TELEMECANIQUE', '025 LDE2                       LD1 DSI elect', 150, 'NOS', '2023-03-31', NULL),
(1159, '025  LD-1 Plant', '5669A1769', 'LIMIT SHOE SWITCH ,OTIS ,LIFT ,OTIS ELEV', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1160, '025  LD-1 Plant', '5871A1846', 'MALE CONNECTOR ,MALE CONNECTOR ,12 MM X', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1161, '025  LD-1 Plant', '5751A0049', 'ALCOHOL RUBIN STERILE HAND DIS ,500 ML,N', '025 LDE2                       LD1 DSI elect', 25, 'NOS', '2023-03-31', NULL),
(1162, '025  LD-1 Plant', '5900A1667', 'AC MOTR;1.5 KW,415 Â± 10%  V,SQUIRREL CAG', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1163, '025  LD-1 Plant', '5958A0019', 'CONT BLK;ELECTRICAL PANEL,TEKNIC,NO,1', '025 L1EW                       Electrical Wards', 140, 'NOS', '2023-03-31', NULL),
(1164, '025  LD-1 Plant', '5900A2144', 'AC MOTR;0.18 KW,415 Â± 10% V,SQUIRREL CAG', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1165, '025  LD-1 Plant', '5648A0118', 'CAMRA&ACC;MIST SEPARATOR', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1166, '025  LD-1 Plant', '0513A0436', 'TEST LEAD SET.', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1167, '025  LD-1 Plant', '0403A0424', 'CGL#1-E-FLOW METER FOR CO ANALYSER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1168, '025  LD-1 Plant', '5669A1130', 'CAR GATE SWITCH ,OTIS ,LIFT ,OTIS ,NX609', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1169, '025  LD-1 Plant', '5011A0040', 'GREASE PMP;MANUAL HAND PUMP ,150 BAR,5.7', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1170, '025  LD-1 Plant', '1256C0033', 'MOTOR SIDE COUPLING HALF', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1171, '025  LD-1 Plant', '1256C0034', 'PUMP SIDE COUPLING HALF', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1172, '025  LD-1 Plant', '0112A0018', 'C.I.GRID RESIST.BOX DRG NO SB-0193/B TS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1173, '025  LD-1 Plant', '1048A0612', 'POWER SUPPLY 5A, 1 PHASE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1174, '025  LD-1 Plant', '0546A5720', 'FITTING,ANGULAR,D10-G1/4,PA', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1175, '025  LD-1 Plant', '0855A0188', 'RECTIFIER MONOBLOCK', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(1176, '025  LD-1 Plant', '0256A1616', 'MPCB.10-16A.3VU1340-1MM00.SIEMENS', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1177, '025  LD-1 Plant', '5506A0155', 'CTRL TRF;0.5 KVA,SINGLE ,DRY ,240 V,12 V', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1178, '025  LD-1 Plant', '0393A0296', 'LF MOVING JAW INSULATOR', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(1179, '025  LD-1 Plant', '5184A0013', 'BRSH CLNG;5 IN,WOOD ,GOOD INSULATION ,UP', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1180, '025  LD-1 Plant', '5871A1847', 'MALE CONNECTOR ,MALE CONNECTOR ,1/2 INCH', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1181, '025  LD-1 Plant', '5641A0147', 'SLCTR SW;10  A,3 POSITION  ,440  VAC,NO', '025 L1EW                       Electrical Wards', 20, 'NOS', '2023-03-31', NULL),
(1182, '025  LD-1 Plant', '0877A0933', '10 AMPS CATRIDGE FUSE (14x51)', '025 LDE2                       LD1 DSI elect', 40, 'NOS', '2023-03-31', NULL),
(1183, '025  LD-1 Plant', '0416A2863', 'TETHER ARM FOR HOLLOW SHAFT ENCODER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1184, '025  LD-1 Plant', '0486A3886', 'Squirrel Cage Induction Motor 0.37KW', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1185, '025  LD-1 Plant', '6045A0189', 'SPL CBL;PROXIMITY SWITCH CABLE ,IFM ELEC', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(1186, '025  LD-1 Plant', '5648A0119', 'CAMRA&ACC;FILTER REGULATOR ELEMENT AW40', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1187, '025  LD-1 Plant', '0860A0033', 'Tie Rod for Weigh feeders at SP#3', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(1188, '025  LD-1 Plant', '5649A0094', 'RTD;PT100 RTD CLASS B TYPE,PT100,3WIRE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1189, '025  LD-1 Plant', '5786A0080', 'TARPAULIN  ,COTTON CANVAS  ,SIZE: 15 X 1', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1190, '025  LD-1 Plant', '0082A0224', 'PIN FOR TOP LANCE COUPLING L.F-2', '025 LD12                       LD#1 DSI Store', 50, 'NOS', '2023-03-31', NULL),
(1191, '025  LD-1 Plant', '5871A1860', 'STRAIGHT CONNECTOR ,STRAIGHT ,8 MM,MACHI', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1192, '025  LD-1 Plant', '5669A1840', 'SPRING, THIMBLE ROD ,OTIS ,LIFT ,OTIS EL', '025 L1EW                       Electrical Wards', 8, 'NOS', '2023-03-31', NULL),
(1193, '025  LD-1 Plant', '5669A1988', 'RELAY COIL ,OTIS ,LIFT ,OTIS ELEVATORS ,', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1194, '025  LD-1 Plant', '6186A0091', 'NW SPARES;SC COUPLER (SM) 6-PORT MODULE', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(1195, '025  LD-1 Plant', '5844A0138', 'PLUG SPARE ,BCH ,HANDLE ASSEMBLY FOR 63A', '025 LD12                       LD#1 DSI Store', 20, 'NOS', '2023-03-31', NULL),
(1196, '025  LD-1 Plant', '0936A0569', 'junction box', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1197, '025  LD-1 Plant', '1103A0589', 'Manual Call Point', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1198, '025  LD-1 Plant', '5014A0090', 'EL SWCH;32A,1,DP SWITCH,HDP,230-250V', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1199, '025  LD-1 Plant', '0877A0929', 'CATRIDGE FUSE 25 AMPS (10x38)', '025 LD12                       LD#1 DSI Store', 40, 'NOS', '2023-03-31', NULL),
(1200, '025  LD-1 Plant', '5341A0127', 'RELAY ACCS,RELAY MODULE,PHOENIX,2966171,', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1201, '025  LD-1 Plant', '5136A0356', 'HOT AIR GUN,060194B004,BOSCH,AIR BLOWER', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1202, '025  LD-1 Plant', '0358A0089', 'METAL CLAD SOCKET 20A 2P', '025 LDE2                       LD1 DSI elect', 65, 'NOS', '2023-03-31', NULL),
(1203, '025  LD-1 Plant', '0779A1451', 'NON MAGNETIC HINGE CLAMP FOR CYLINDER', '025 LDE2                       LD1 DSI elect', 9, 'NOS', '2023-03-31', NULL),
(1204, '025  LD-1 Plant', '6028A0247', 'PWR DSTBN PNL;TERMINAL BLOCK ,ELMEX ,CST', '025 L1EW                       Electrical Wards', 500, 'NOS', '2023-03-31', NULL),
(1205, '025  LD-1 Plant', '1586A1187', 'PLC  5  SERIAL  CABLE', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1206, '025  LD-1 Plant', '0918A0609', 'MODIFIED STUD FOR 28T COIL TONG', '025 LDE2                       LD1 DSI elect', 6, 'SET', '2023-03-31', NULL),
(1207, '025  LD-1 Plant', '0371A0012', 'COPAL (Copper & Alluminum Bimetal) Sheet', '025 LDE2                       LD1 DSI elect', 4, 'SHT', '2023-03-31', NULL),
(1208, '025  LD-1 Plant', '5641A0248', 'SLCTR SW;6 A,3P 3WAY NO/OFF ,24 V,YES ,5', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1209, '025  LD-1 Plant', '1304A0559', 'Wall mounted RACK 12 U (Comrack/APW)', '025 LD12                       LD#1 DSI Store', 1, 'PCE', '2023-03-31', NULL),
(1210, '025  LD-1 Plant', '0380A0461', 'Limit Switch BCH NLTPR-2', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1211, '025  LD-1 Plant', '0958A1747', 'PCB ASYMBLY RELAYCARD', '025 L1EW                       Electrical Wards', 1, 'PCE', '2023-03-31', NULL),
(1212, '025  LD-1 Plant', '5890A0890', 'CNTCR;37.4 A,3 ,110 V,AC ,415 V,S2 ,AC ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1213, '025  LD-1 Plant', '0546G0037', 'SS TYPE 5 PIN PLUG 30A 500V FOR TEMP.MEA', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(1214, '025  LD-1 Plant', '0081A0770', 'FLEXIBLE COUPLING FOR CROSSTRANSFER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1215, '025  LD-1 Plant', '5872A0580', 'SW GR&CB SPR,ACTUATOR,SIEMENS,PUSH BUTTO', '025 LDE2                       LD1 DSI elect', 47, 'NOS', '2023-03-31', NULL),
(1216, '025  LD-1 Plant', '1877A0324', 'GLAND PACKING-M/C-52NE7581', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1217, '025  LD-1 Plant', '5734A0126', 'BLACK INK RIBBON  ,MAX LETATWIN  ,LM-IR5', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1218, '025  LD-1 Plant', '5959A1856', 'PROXIMITY SWITCH ,HARZOG ,8-6835-341514-', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1219, '025  LD-1 Plant', '5871A1873', 'EQUAL TEE ,EQUAL TEE ,12 MM,MACHINING ,S', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1220, '025  LD-1 Plant', '0852A0249', 'SRP126C/GB', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1221, '025  LD-1 Plant', '5641A0198', 'SLCTR SW;10 A,4 POSITION SELECTOR WITH O', '025 LDE2                       LD1 DSI elect', 19, 'NOS', '2023-03-31', NULL),
(1222, '025  LD-1 Plant', '5620A2049', 'PLC SPR;MEMORY CARD,SIEMENS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1223, '025  LD-1 Plant', '0853A2915', 'MPCB Manual motor starter,MS116-12', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1224, '025  LD-1 Plant', '5598A0048', 'FERRL MRKR;FERRULE,3.5MM,NYLON,HT/LT', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(1225, '025  LD-1 Plant', '6088A0104', 'ELECTRONIC HOOTER ,SYSTEM SENSOR ,PA400R', '025 LDE2                       LD1 DSI elect', 9, 'NOS', '2023-03-31', NULL),
(1226, '025  LD-1 Plant', '5701A0094', 'ELECT SOCKT/PLG;16A,METALLIC,5,SOCKET', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1227, '025  LD-1 Plant', '5684A0072', 'SPL LGHT;EMERGENCY,YES,PORTABLE,220VAC', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1228, '025  LD-1 Plant', '6088A0256', 'BATTERY{12X7AH) NOS,EXIDE  ,FDA PANEL ,T', '025 LDE2                       LD1 DSI elect', 8, 'NOS', '2023-03-31', NULL),
(1229, '025  LD-1 Plant', '0101A1504', 'Modified SS Hex head bolt with flat', '025 LDE2                       LD1 DSI elect', 100, 'NOS', '2023-03-31', NULL),
(1230, '025  LD-1 Plant', '5607A0088', 'RELAY,NO MODIFIER,MINI RLAY DPDT 2POL 2C', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1231, '025  LD-1 Plant', '5649A0129', 'RTD;PT-100 ,PT100 ,3 WIRE, DUPLEX ,CLASS', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1232, '025  LD-1 Plant', '5607A1203', 'RELAY;ELECTROMAGNETIC ,MASTER TRIP RELAY', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1233, '025  LD-1 Plant', '5479A0345', 'PR GUAGE;0-10 KG/CM2,BOTTOM BACK ,AIR ,2', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1234, '025  LD-1 Plant', '0606A0109', 'HYDEX COUPLING #65', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1235, '025  LD-1 Plant', '0244A1519', 'AUX. CONTACTOR FOR MILL MCC', '025 LDE2                       LD1 DSI elect', 7, 'NOS', '2023-03-31', NULL),
(1236, '025  LD-1 Plant', '1877A1453', 'LOP POSITION INDICATOR PCB-TKEI LIFT', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1237, '025  LD-1 Plant', '5537A0115', 'BATTERY;LITHIUM CR123A,GAS DETECTOR,3V', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(1238, '025  LD-1 Plant', '0546A1974', 'Drill M/C IFM  M 12 connector(EVC009)', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1239, '025  LD-1 Plant', '0367A0114', 'INDUSTRIAL SIREN', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1240, '025  LD-1 Plant', '0853A2763', 'MS116-4 ABB MPCB', '025 LDE2                       LD1 DSI elect', 2, 'PCE', '2023-03-31', NULL),
(1241, '025  LD-1 Plant', '5620A2474', '20 POSITION NEMA SCREW CLAMP B ,ALLEN BR', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1242, '025  LD-1 Plant', '5772A0310', 'PUSH BTN;PUSH BUTTON ACTUATOR ,BLUE ,TEK', '025 L1EW                       Electrical Wards', 10, 'PCE', '2023-03-31', NULL),
(1243, '025  LD-1 Plant', '5871A1854', 'STRAIGHT CONNECTOR ,STRAIGHT ,6 MM,MACHI', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1244, '025  LD-1 Plant', '5890A0473', 'CONTACTOR,6A,4,110V,RELAY,110V,S0,DC,50H', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1245, '025  LD-1 Plant', '5620A0525', 'PLC SPR,BACK UP BATTERY,SIEMENS,6ES7971-', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1246, '025  LD-1 Plant', '5900A1042', 'AC MOTR;1.5KW,415+10% -15%VAC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1247, '025  LD-1 Plant', '1852A0036', 'SS KEY FOR LF CONTACT PAD', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1248, '025  LD-1 Plant', '5701A0091', 'ELECT SOCKT/PLG;16A,METALLIC,5,PLUG', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1249, '025  LD-1 Plant', '0758A1225', 'PROXIMITY  CONNECTOR  FOR CC MARKING M/C', '025 LD12                       LD#1 DSI Store', 3, 'NOS', '2023-03-31', NULL),
(1250, '025  LD-1 Plant', '5669A1276', 'CARBON CONTACT(SMALL) ,OTIS ,LIFT ,OTIS', '025 L1EW                       Electrical Wards', 9, 'NOS', '2023-03-31', NULL),
(1251, '025  LD-1 Plant', '0256A2369', 'MPCB 6.3A WITH AUX.CONTACT', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1252, '025  LD-1 Plant', '6130A0017', 'TEMPERATURE & HUMIDITY DISPLAY ,CASIO ,I', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1253, '025  LD-1 Plant', '5844A0137', 'PLUG SPARE ,BCH ,HANDLE ASSEMBLY FOR 32A', '025 LD12                       LD#1 DSI Store', 20, 'NOS', '2023-03-31', NULL),
(1254, '025  LD-1 Plant', '5600A0044', 'SPARE,WIREROPE;PULL CHORD WIRE ROPE', '025 LDE2                       LD1 DSI elect', 200, 'M', '2023-03-31', NULL),
(1255, '025  LD-1 Plant', '5748A0181', 'FUSE,FLUKE MULTIMETER FUSE,440MA,1000V,3', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1256, '025  LD-1 Plant', '5544A5256', 'BOLT;HEX HEAD ,12 MM,150  MM,80  ,SS304', '025 LDE2                       LD1 DSI elect', 100, 'SET', '2023-03-31', NULL),
(1257, '025  LD-1 Plant', '5844A0136', 'PLUG SPARE ,BCH ,HANDLE ASSEMBLY FOR 16A', '025 LD12                       LD#1 DSI Store', 20, 'NOS', '2023-03-31', NULL),
(1258, '025  LD-1 Plant', '5649A0126', 'RTD;PT-100 ,3 WIRE PT 100 ,3 WIRE SIMPLE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1259, '025  LD-1 Plant', '5620A3379', 'SLIM LINE RELAY ,ALLEN BRADLEY ,700-HK32', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1260, '025  LD-1 Plant', '1304A0490', 'SC Pigtail (MM) GFR 61/G2', '025 LD12                       LD#1 DSI Store', 16, 'PCE', '2023-03-31', NULL),
(1261, '025  LD-1 Plant', '0546A1249', 'MOISTURE DETECTOR FILTER', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1262, '025  LD-1 Plant', '5772A0105', 'PUSH BTTN;MOMENTARY PUSH BUTTON,RED', '025 L1EW                       Electrical Wards', 40, 'NOS', '2023-03-31', NULL),
(1263, '025  LD-1 Plant', '5544A4707', 'BOLT;HEX HEAD ,10 MM,80 MM,80 ,SS304 ,IS', '025 L1EW                       Electrical Wards', 130, 'NOS', '2023-03-31', NULL),
(1264, '025  LD-1 Plant', '5741A0495', 'CHEM SPL;EPOXY PUTTY', '025 L1EW                       Electrical Wards', 2, 'KG', '2023-03-31', NULL),
(1265, '025  LD-1 Plant', '1877A0334', 'GUIDE SHOE GIBS-M/C-52NE7581', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1266, '025  LD-1 Plant', '5871A1858', 'MALE CONNECTOR ,MALE CONNECTOR ,1/4X1/4', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1267, '025  LD-1 Plant', '0853A2909', 'CB 0.1-0.16A , MS116-0.16', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1268, '025  LD-1 Plant', '5497A0453', 'MCB;6 A,3 ,415 V,3 KA,C ,50 HZ,AC ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1269, '025  LD-1 Plant', '5552A0315', 'MPCB;8A,3,415V,3KW,50HZ,5.5-8A,1NO+1NC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1270, '025  LD-1 Plant', '0397A0423', 'SS WASHER FOR LF FIX JAW  DOWEL PIN', '025 LDE2                       LD1 DSI elect', 35, 'NOS', '2023-03-31', NULL),
(1271, '025  LD-1 Plant', '0556A1514', 'HEAVY DUTY LONG BARREL CU SOCKET 95 MM2', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1272, '025  LD-1 Plant', '5871A1870', 'NIPPLE ,NIPPLE ,1/2 IN,MACHINING ,SCH 40', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1273, '025  LD-1 Plant', '5872A0594', 'SW GR&CB SPR,AUX CONTACT,SIEMENS,PUSH BU', '025 LDE2                       LD1 DSI elect', 37, 'NOS', '2023-03-31', NULL),
(1274, '025  LD-1 Plant', '5649A0128', 'RTD;PT-100 ,3 WIRE PT 100 ,3 WIRE SIMPLE', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1275, '025  LD-1 Plant', '0517A0742', 'Assy_3Magnets_CarTOP_ThyssenKrupp Lift', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1276, '025  LD-1 Plant', '5325A0003', 'IC BASE,28,COPPER,NO SPECIAL FEATURE,SIG', '025 LDE2                       LD1 DSI elect', 4, 'NOS', '2023-03-31', NULL),
(1277, '025  LD-1 Plant', '0763ZA007', 'CURRENT PANEL METER, 40-0-40 MA', '025 LD12                       LD#1 DSI Store', 5, 'NOS', '2023-03-31', NULL),
(1278, '025  LD-1 Plant', '5772A0144', 'PUSH BTN;FLUSH MOUNTED P.B ,GREEN ,TEKNI', '025 L1EW                       Electrical Wards', 60, 'NOS', '2023-03-31', NULL),
(1279, '025  LD-1 Plant', '6183A0015', 'MASTER CONTROLLER;220 VAC,16 A,4-0-4 ,BI', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1280, '025  LD-1 Plant', '5872A3149', 'ROTARY SWITCH ,KAYCEE ,ACS 800 DRIVE PAN', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(1281, '025  LD-1 Plant', '5607A0452', 'RELAY,NO MODIFIER,SIEMENS PLC,99%,PLUG I', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1282, '025  LD-1 Plant', '5620A2705', 'EXT.MEMORY CRD MAIN BATTERY ,SCHNEIDER ,', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1283, '025  LD-1 Plant', '0082A0225', 'BUSH FOR COUPLING LF-2', '025 LD12                       LD#1 DSI Store', 50, 'NOS', '2023-03-31', NULL),
(1284, '025  LD-1 Plant', '0546A0781', 'PAPER FILTER', '025 LD12                       LD#1 DSI Store', 2, 'NOS', '2023-03-31', NULL),
(1285, '025  LD-1 Plant', '1586A0295', '10 FEET PROGRAMMER', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1286, '025  LD-1 Plant', '5502A0291', 'CPLNG SPR,SPIDER,L225,LOVEJOY,FLEXIBLE,N', '025 LDE2                       LD1 DSI elect', 10, 'NOS', '2023-03-31', NULL),
(1287, '025  LD-1 Plant', '5739A0071', 'TIMER;DIGITAL TIMER ,110 VAC,SIEMENS ,24', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1288, '025  LD-1 Plant', '5552A0334', 'MPCB;1.1 - 1.6A,3,415V,0.55KW,50HZ', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1289, '025  LD-1 Plant', '5859A0513', 'INSLTG MTR;INSULATI0N DISC ,SYNDANYIO IM', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1290, '025  LD-1 Plant', '5544A2994', 'BOLT;HEX HEAD ,12 MM,50  MM,70 ,SS 316 ,', '025 L1EW                       Electrical Wards', 100, 'NOS', '2023-03-31', NULL),
(1291, '025  LD-1 Plant', '1304A0427', '1 GB RAM DDR2 667 MHz desktop', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1292, '025  LD-1 Plant', '6028A0235', 'PWR DSTBN PNL;TERMINAL BLOCK ,ELMEX ,CST', '025 L1EW                       Electrical Wards', 300, 'NOS', '2023-03-31', NULL),
(1293, '025  LD-1 Plant', '5999A0052', 'STICKER;FREE ,SIGNAGES ,ACP WITH ADHESIV', '025 L190                       Vessel Elect str', 3456, '\"2', '2023-03-31', NULL),
(1294, '025  LD-1 Plant', '0958A2818', 'PCB ASY WTREY_1DIGDPL_F TIC-2', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1295, '025  LD-1 Plant', '5772A0104', 'PUSH BTTN;MOMENTARY PUSH BUTTON,BLACK', '025 L1EW                       Electrical Wards', 60, 'NOS', '2023-03-31', NULL),
(1296, '025  LD-1 Plant', '5669A2016', 'CWT GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', '025 L1EW                       Electrical Wards', 4, 'NOS', '2023-03-31', NULL),
(1297, '025  LD-1 Plant', '0712A0347', 'ASSY_FIN_200_SLOWUPDN_SHAFT', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL);
INSERT INTO `t_stock_sap` (`sl`, `plant`, `mtcd`, `material`, `stloc`, `qty`, `unit`, `udt`, `uby`) VALUES
(1298, '025  LD-1 Plant', '5607A0630', 'RELAY,NO MODIFIER,SWITCHING,+/-5%,PLUGGA', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1299, '025  LD-1 Plant', '0274A0102', 'SPLIT PIN FOR VI MECHANISM OF LF', '025 LDE2                       LD1 DSI elect', 30, 'NOS', '2023-03-31', NULL),
(1300, '025  LD-1 Plant', '5669A1281', 'COIL ,OTIS ,LIFT ,OTIS ,222CY3 ,PART ,NO', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1301, '025  LD-1 Plant', '5669A1550', 'COIL-XU&XD ,OTIS ,LIFT ,OTIS ELEVATORS ,', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1302, '025  LD-1 Plant', '5739A0101', 'TIMER;TIMER NOS,110 VAC,SELEC ,110 VAC,8', '025 LDE2                       LD1 DSI elect', 3, 'NOS', '2023-03-31', NULL),
(1304, '025  LD-1 Plant', '5532A0335', 'GAS ANLYR SPR;14/10 mm silicon tube', '025 LDE2                       LD1 DSI elect', 5, 'M', '2023-03-31', NULL),
(1305, '025  LD-1 Plant', '5620A2704', 'QUANTUM CPU BATTERY ,SCHNEIDER ,990XCP98', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1306, '025  LD-1 Plant', '5669A1987', 'RELAY COIL ,OTIS ,LIFT ,OTIS ELEVATORS ,', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1307, '025  LD-1 Plant', '5669A2004', 'DOOR PULLY BRACKET LH ,OTIS ,LIFT ,OTIS', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1308, '025  LD-1 Plant', '1877AA082', 'TC Relay 12 Amp, 110 V', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1309, '025  LD-1 Plant', '0485A0846', 'RELAY', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1310, '025  LD-1 Plant', '0345A0262', 'LED LAMP WITH 110V AC', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1311, '025  LD-1 Plant', '0958A2812', 'ON DELAY TIMER_MK-TC_TY-TA2-DT2', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(1312, '025  LD-1 Plant', '5552A0416', 'MPCB;1.6A,3,690V,30KW,50 - 60HZ,1-1.6A', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1313, '025  LD-1 Plant', '5378A0039', 'O-RING CORD;VITON,3MM,85SHA,200Â°C', '025 LDE2                       LD1 DSI elect', 25, 'M', '2023-03-31', NULL),
(1314, '025  LD-1 Plant', '5871A1863', 'UNION ,UNION ,6X6 MM,MACHINING ,SCH 40 ,', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1315, '025  LD-1 Plant', '0556A1637', 'CABLE PIN TYPE SOCKET 0.75 MM2', '025 LDE2                       LD1 DSI elect', 1800, 'NOS', '2023-03-31', NULL),
(1316, '025  LD-1 Plant', '1309A0208', 'MEMORY STICK PRO DUO', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1317, '025  LD-1 Plant', '3586C5087', 'SPACER 340', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1318, '025  LD-1 Plant', '0855A0215', 'BRIDGE RECTIFIER', '025 L1EW                       Electrical Wards', 5, 'NOS', '2023-03-31', NULL),
(1319, '025  LD-1 Plant', '0160A0372', 'Steel Wire rope 8mm', '025 LDE2                       LD1 DSI elect', 8, 'M', '2023-03-31', NULL),
(1320, '025  LD-1 Plant', '5669A2003', 'ARM ROLLER ,OTIS ,LIFT ,OTIS ELEVATORS ,', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1321, '025  LD-1 Plant', '5669A1283', 'COIL ,OTIS ,LIFT ,OTIS ,222EB1 ,PART ,NO', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1322, '025  LD-1 Plant', '0798A0401', 'SCANNING,EDITING & CLEANING (SIZE A3)', '025 L190                       Vessel Elect str', 205, 'NOS', '2023-03-31', NULL),
(1323, '025  LD-1 Plant', '5890A0609', 'CONTACTOR;6A,4,110V,RELAY,110V', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1324, '025  LD-1 Plant', '5615A0057', 'EL CNNTR;RIBBON CONNECTOR,CONNECTION,8', '025 LDE2                       LD1 DSI elect', 6, 'NOS', '2023-03-31', NULL),
(1325, '025  LD-1 Plant', '0327A0057', 'HP 11 Black print-head', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1326, '025  LD-1 Plant', '5956A0429', 'INST SPR;24V SOLENOID PLUG,N/A', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(1327, '025  LD-1 Plant', '0958A2802', 'PCB ASY _SNUBBER CARD - EMI_TIC - 2', '025 L1EW                       Electrical Wards', 20, 'NOS', '2023-03-31', NULL),
(1328, '025  LD-1 Plant', '3586TG007', '57       SPACER 110X9', '025 LD12                       LD#1 DSI Store', 12, 'NOS', '2023-03-31', NULL),
(1329, '025  LD-1 Plant', '5615A0058', 'EL CNNTR;D TYPE,CONNECTION,9,24V,10A', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1330, '025  LD-1 Plant', '5669A2005', 'DOOR PULLY BRACKET RH ,OTIS ,LIFT ,OTIS', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1331, '025  LD-1 Plant', '5341A0131', 'RELAY ACCS,RELAY SOCKET,PHOENIX,PLC-BSC-', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1332, '025  LD-1 Plant', '0546A4095', 'F-TYPE LIMIT SW FOR GREASE SYSTEM', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1333, '025  LD-1 Plant', '5871A1853', 'FERRULE ,FERRULE ,6 MM,MACHINING ,SCH 40', '025 L1EW                       Electrical Wards', 100, 'NOS', '2023-03-31', NULL),
(1334, '025  LD-1 Plant', '5544A2887', 'BOLT ;HEX HEAD,12MM,40MM,80,SS 316', '025 LDE2                       LD1 DSI elect', 50, 'NOS', '2023-03-31', NULL),
(1335, '025  LD-1 Plant', '3586TG007', '58       SPACER 110X36', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(1336, '025  LD-1 Plant', '5890A0756', 'CONTCR;1A,3,24V,POWER,690V,AC,50HZ,1NC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1337, '025  LD-1 Plant', '0380A1079', 'Limit Switch', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1338, '025  LD-1 Plant', '5772A0143', 'PUSH BTN;PB STATION ,GREEN ,TEKNIC ,FLUS', '025 L1EW                       Electrical Wards', 20, 'NOS', '2023-03-31', NULL),
(1339, '025  LD-1 Plant', '5669A1282', 'COIL ,OTIS ,LIFT ,OTIS ,222CZ1 ,PART ,NO', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1340, '025  LD-1 Plant', '0381A0202', 'CONNECTOR WITH 2 m PVC cable', '025 LDE2                       LD1 DSI elect', 2, 'NOS', '2023-03-31', NULL),
(1341, '025  LD-1 Plant', '5890A0674', 'CONTACTOR;18A,3,24V,POWER,415V,S00,AC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1342, '025  LD-1 Plant', '5890A1178', 'CNTCR;18 A,3 ,24 VDC,POWER - AC ,415 V,S', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1343, '025  LD-1 Plant', '5532A0236', 'GAS ANLYR SPR;Analyser filter', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1344, '025  LD-1 Plant', '5620A2706', 'EXT.MEMORY CRD AUX BATTERY ,SCHNEIDER ,T', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1345, '025  LD-1 Plant', '0798A0404', 'PRINTING WITHOUT LAYOUT (FLOPPY) COLOUR', '025 L190                       Vessel Elect str', 180, 'NOS', '2023-03-31', NULL),
(1346, '025  LD-1 Plant', '5871A1884', 'REDUCER ,SOCKET ,1/2X1/4 IN,MACHINING ,S', '025 L1EW                       Electrical Wards', 50, 'NOS', '2023-03-31', NULL),
(1347, '025  LD-1 Plant', '1877A0279', 'BRAKE RIVET-145C3', '025 L1EW                       Electrical Wards', 60, 'NOS', '2023-03-31', NULL),
(1348, '025  LD-1 Plant', '5669A1999', 'ARC BARRIER ,OTIS ,LIFT ,OTIS ELEVATORS', '025 L1EW                       Electrical Wards', 6, 'NOS', '2023-03-31', NULL),
(1349, '025  LD-1 Plant', '5669A1295', 'CONDENSER/250MFD ,OTIS ,LIFT ,OTIS ,NAA2', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1350, '025  LD-1 Plant', '1877A0252', 'COIL  EB1', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1351, '025  LD-1 Plant', '3586TG007', '69       BUSH', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(1352, '025  LD-1 Plant', '5669A1600', 'CONNECTOR ,OTIS ,LIFT ,OTIS ELEVATORS ,1', '025 L1EW                       Electrical Wards', 3, 'NOS', '2023-03-31', NULL),
(1353, '025  LD-1 Plant', '1877A0248', 'COIL CY3', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1354, '025  LD-1 Plant', '0646A0491', 'CIRCLIP LIGHT A110 IS:3075', '025 LD12                       LD#1 DSI Store', 6, 'NOS', '2023-03-31', NULL),
(1355, '025  LD-1 Plant', '0082A0223', 'BARREL BUSH FOR L.F-2', '025 LD12                       LD#1 DSI Store', 10, 'NOS', '2023-03-31', NULL),
(1356, '025  LD-1 Plant', '0122A0967', 'Response Indicator', '025 L1EW                       Electrical Wards', 10, 'NOS', '2023-03-31', NULL),
(1357, '025  LD-1 Plant', '5890A0729', 'CONTCR;18A,3,110V,POWER,400VAC,S00,AC', '025 LDE2                       LD1 DSI elect', 1, 'NOS', '2023-03-31', NULL),
(1358, '025  LD-1 Plant', '0470A0201', 'ECL - FLUSH ACTUATOR', '025 LDE2                       LD1 DSI elect', 15, 'NOS', '2023-03-31', NULL),
(1359, '025  LD-1 Plant', '0852A0305', 'ECL - STAYPUT  SELECTOR ACTUATOR', '025 LDE2                       LD1 DSI elect', 5, 'NOS', '2023-03-31', NULL),
(1360, '025  LD-1 Plant', '5871A1840', 'FERRULE ,FERRULE ,12 MM,MACHINING ,SCH 4', '025 L1EW                       Electrical Wards', 100, 'NOS', '2023-03-31', NULL),
(1361, '025  LD-1 Plant', '5669A1078', 'CIS PANEL ,OTIS ,LIFT ,OTIS ,NO6599C2 ,P', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1362, '025  LD-1 Plant', '1304A0474', 'SC Connector Panel', '025 LD12                       LD#1 DSI Store', 6, 'PCE', '2023-03-31', NULL),
(1363, '025  LD-1 Plant', '0160A0371', 'Steel Wire rope 13mm', '025 LDE2                       LD1 DSI elect', 2, 'M', '2023-03-31', NULL),
(1364, '025  LD-1 Plant', '0958A2811', 'OEN RELAY 2R-3-24V', '025 L1EW                       Electrical Wards', 2, 'NOS', '2023-03-31', NULL),
(1365, '025  LD-1 Plant', '5544A3161', 'BOLT;HEX HEAD  ,12  MM,60  MM,80  ,SS 31', '025 LDE2                       LD1 DSI elect', 20, 'NOS', '2023-03-31', NULL),
(1366, '025  LD-1 Plant', '0556A1065', 'FORK TYPE TERMINAL 1.5', '025 LD12                       LD#1 DSI Store', 300, 'NOS', '2023-03-31', NULL),
(1367, '025  LD-1 Plant', '0556A1066', 'FORK TYPE TERMINAL 2.5', '025 LD12                       LD#1 DSI Store', 250, 'NOS', '2023-03-31', NULL),
(1368, '025  LD-1 Plant', '1256A2474', 'SPACER FOR W/S UNIT OF CC#1', '025 LD12                       LD#1 DSI Store', 4, 'NOS', '2023-03-31', NULL),
(1369, '025  LD-1 Plant', '5669A1259', 'BRAKE RESISTOR ,OTIS ,LIFT ,OTIS ,232B21', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1370, '025  LD-1 Plant', '5669A1582', 'RESISTOR/500 OHM ,OTIS ,LIFT ,OTIS ELEVA', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1371, '025  LD-1 Plant', '5669A1579', 'RESISTOR/1K ,OTIS ,LIFT ,OTIS ELEVATORS', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1372, '025  LD-1 Plant', '5669A2000', 'RESISTOR ,OTIS ,LIFT ,OTIS ELEVATORS ,23', '025 L1EW                       Electrical Wards', 1, 'NOS', '2023-03-31', NULL),
(1373, '025  LD-1 Plant', '0082A0226', 'PIN 3/8\" BSP FOR L.F-2', '025 LD12                       LD#1 DSI Store', 1, 'NOS', '2023-03-31', NULL),
(1374, '025  LD-1 Plant', '0798A0409', 'Stitch binding up to 400 pages', '025 L190                       Vessel Elect str', 50, 'NOS', '2023-03-31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `t_testing`
--

CREATE TABLE `t_testing` (
  `dt` datetime NOT NULL,
  `data` varchar(2000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_testing`
--

INSERT INTO `t_testing` (`dt`, `data`) VALUES
('2024-03-21 14:22:03', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cnm,date_format(mdt,`%d.%m.%Y`) as mdt,mnm from t_stock_process where sts != `Delete`  and left(cdt,10) >= `2024-02-22` and left(cdt,10) <= `2024-04-04` and process = `StockAdjustmentExcel` order by id desc'),
('2024-03-21 14:22:04', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cnm,date_format(mdt,`%d.%m.%Y`) as mdt,mnm from t_stock_process where sts != `Delete`  and left(cdt,10) >= `2024-02-22` and left(cdt,10) <= `2024-04-04` and process = `StockAdjustmentExcel` order by id desc'),
('2024-03-21 14:22:11', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cnm,date_format(mdt,`%d.%m.%Y`) as mdt,mnm from t_stock_process where sts != `Delete`  and left(cdt,10) >= `2024-02-22` and left(cdt,10) <= `2024-04-04` order by id desc'),
('2024-03-21 14:22:12', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cnm,date_format(mdt,`%d.%m.%Y`) as mdt,mnm from t_stock_process where sts != `Delete`  and left(cdt,10) >= `2024-02-22` and left(cdt,10) <= `2024-04-04` order by id desc'),
('2024-03-21 14:22:12', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cnm,date_format(mdt,`%d.%m.%Y`) as mdt,mnm from t_stock_process where sts != `Delete`  and left(cdt,10) >= `2024-02-22` and left(cdt,10) <= `2024-04-04` order by id desc'),
('2024-03-21 14:25:23', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,concat(`<a href=\"#\" onclick=\"deleteStock(`,id,`,``,process,``);\" >Delete</a>`) as del,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cby from t_stock_process where sts != `Delete`  order by id desc'),
('2024-03-21 14:26:15', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cby from t_stock_process where sts != `Delete`  order by id desc'),
('2024-03-21 14:26:39', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cby from t_stock_process where sts != `Delete`  and process = `StockAdjustment` order by id desc'),
('2024-03-21 14:26:40', 'select concat(`<input type=\"checkbox\" class=\"chkstock\" value=\"`,id,`\" />`) as chk,concat(`<a href=\"#\" onclick=\"viewStock(`,id,`,``,process,``);\" >View</a>`) as view,id,process,descp,isto,tknby,date_format(cdt,`%d.%m.%Y`) as cdt,cby from t_stock_process where sts != `Delete`  and process = `StockAdjustment` order by id desc'),
('2024-07-16 14:24:53', 'call PROC_AddStockItem_Call(0,NULL,`1001E9090`,`ABCINDIA`,`1`,`Toolkit Store`,``,``,``,``,`NOS`,``,``,``,``,`N`,sysdate(),`usertool`,`1`)');

-- --------------------------------------------------------

--
-- Table structure for table `t_user`
--

CREATE TABLE `t_user` (
  `id` int(11) NOT NULL,
  `uid` varchar(30) DEFAULT NULL,
  `unm` varchar(50) DEFAULT NULL,
  `utp` varchar(30) DEFAULT NULL,
  `loc` varchar(30) DEFAULT NULL,
  `pwd` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_user`
--

INSERT INTO `t_user` (`id`, `uid`, `unm`, `utp`, `loc`, `pwd`) VALUES
(1, 'admin', 'Administrator', 'Admin', '', 'welcome@123'),
(2, 'usertool', 'User Toolkit', 'User', 'Toolkit Store', 'welcome@123'),
(3, 'uservess', 'Vessel User', 'User', 'Vessel', 'welcome@123'),
(4, 'usercast', 'User Caster', 'User', 'Caster', 'welcome@123'),
(5, 'usersmlp', 'User SMLP', 'User', 'SMLP', 'welcome@123');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stock`
-- (See below for the actual view)
--
CREATE TABLE `v_stock` (
`skid` int(11)
,`itid` int(10)
,`sts` varchar(40)
,`mtcd` varchar(20)
,`material` varchar(200)
,`loc` varchar(40)
,`sloc` varchar(40)
,`ssloc` varchar(40)
,`make` varchar(40)
,`critical` varchar(5)
,`uom` varchar(30)
,`avl` double
,`sti` double unsigned
,`sto` double unsigned
,`tri` double unsigned
,`tro` double unsigned
,`adi` double unsigned
,`ado` double unsigned
,`scp` double unsigned
,`rsv` double unsigned
,`isr` double unsigned
);

-- --------------------------------------------------------

--
-- Table structure for table `v_stock_base`
--

CREATE TABLE `v_stock_base` (
  `skid` int(11) NOT NULL,
  `itid` int(10) DEFAULT NULL,
  `mtcd` varchar(20) DEFAULT NULL,
  `material` varchar(200) DEFAULT NULL,
  `make` varchar(40) DEFAULT NULL,
  `uom` varchar(30) DEFAULT NULL,
  `critical` varchar(5) DEFAULT NULL,
  `loc` varchar(40) NOT NULL,
  `sloc` varchar(40) DEFAULT NULL,
  `ssloc` varchar(40) DEFAULT NULL,
  `sts` varchar(40) DEFAULT NULL,
  `sti` double UNSIGNED DEFAULT '0',
  `sto` double UNSIGNED DEFAULT '0',
  `tri` double UNSIGNED DEFAULT '0',
  `tro` double UNSIGNED DEFAULT '0',
  `adi` double UNSIGNED DEFAULT '0',
  `ado` double UNSIGNED DEFAULT '0',
  `scp` double UNSIGNED DEFAULT '0',
  `rsv` double UNSIGNED DEFAULT '0',
  `isr` double UNSIGNED DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `v_stock_base`
--

INSERT INTO `v_stock_base` (`skid`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `sts`, `sti`, `sto`, `tri`, `tro`, `adi`, `ado`, `scp`, `rsv`, `isr`) VALUES
(100001, 10001, '', '3 PAIR X0.5 CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100002, 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 20, 10, 0, 7, 7, 0, 0, 0, 0),
(100003, 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 132, 7, 0, 2, 0, 0, 5, 0, 0),
(100004, 10004, '0025C0092', 'BRG ROLLER SINGLE ROW CYL MET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100005, 10005, '0030A0051', 'BRG.ROLLER,DOUBLE ROW,  23136,CCW33', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100006, 10006, '0030B0068', 'BRG.ROLLER,DOUBLE ROW,SP 22226 CCW33', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100007, 10007, '0031A0160', 'BRG. 32312 TAPER ROLLER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100008, 10008, '0031B0007', 'BRG.ROLLERTAPER,SINGLEROW,METRIC(31309,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100009, 10009, '0083A0023', 'TYRE TYPE COUPING & SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100010, 10010, '0088A0095', 'THREADED CABLE GLAND SIZE M20X1.5', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100011, 10011, '0093A0119', 'CABLE GLAND  19 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 2, 0, 6, 266, 0, 0, 0, 0),
(100012, 10012, '0093A0120', 'CABLE GLAND  22MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100013, 10013, '0096A0138', 'NUTM16', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100014, 10014, '0101D0096', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 35MM\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100015, 10015, '0101D0097', 'HEX HEAD, HIGH TENSILE BOLT, 8MM, 40MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100016, 10016, '0101D0099', '\"HEX HEAD, HIGH TENSILE BOLT, 8MM, 50MM\"', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100017, 10017, '0122A0456', 'HELMET,FRP, DGMS APPROVED, MAKE:', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 14, 0, 0, 29, 0, 0, 0, 0),
(100018, 10018, '0122B0064', 'SAFETY ITEMS ( BARICADE  TAPE)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 142, 0, 0, 0, 0),
(100019, 10019, '0124A0003', 'HANDGLAVES (LEATHER CUM CANVAS)', '', 'PAA', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100020, 10020, '0150A0025', 'BREATHING APPARATUS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100021, 10021, '0162A0003', 'BULLDOG GRIP 13 MM WIRE ROPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100022, 10022, '0162A0004', 'BULLDOG GRIP 16MM WIRE ROPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100023, 10023, '0162A0007', 'BULLDOG GRIP  25mm', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100024, 10024, '0177A0733', 'Ferrule for 6mm OD x 1mm thick', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100025, 10025, '0207A0048', 'GENERAL TOOLS   -plie', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 25, 0, 0, 0, 0),
(100026, 10026, '0217A0039', 'MOT.LEAD,1KV,CU,16X1C,HRE ELSTMR INSL', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100027, 10027, '0217A0042', 'FLEX.CABLE,1KV,CU,70X1C,HRE INSULN.', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100028, 10028, '0217A0044', 'FLEX CABLE,1KV,CU,120 X1C ,HRE,INSULN', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100029, 10029, '0217A0045', 'FLEX CABLE,1 KV,CU,150X1C,HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100030, 10030, '0217A0046', 'FLEX CABLE 1 KV CU 240*1C HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100031, 10031, '0217A0049', 'FLEX LEAD,1 KV,CU,2.5X1C,HRE INSULN', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100032, 10032, '0237A0081', 'GL.PRPS,FLEX,1KV,CU,2.5X4C,RUBR,RUBR SH', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100033, 10033, '0237A0082', 'GL PRPS FLEX,1KV,CU,6X4C,RUBR,RUBR SH', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100034, 10034, '0237A0087', 'MAGNET CABLE 35SQMM X 2C CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100035, 10035, '0237A0090', 'CABLE FOR LIGHTING PURPOSE,1.5SQ.MM', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100036, 10036, '0244A0061', 'CONTACTOR POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100037, 10037, '0244A0084', 'CONTACTOR POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100038, 10038, '0244A0155', '3 POLE 300A CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100039, 10039, '0244A0167', 'CONTACTOR RELAY 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 71, 0, 0, 0, 0),
(100040, 10040, '0244A0496', 'CONTACTOR,110A,110VAC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100041, 10041, '0244A0586', 'DS PLUG 16AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 39, 0, 0, 0, 0),
(100042, 10042, '0244A0587', 'DS SOCKET 16AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100043, 10043, '0244A0658', 'HRC 16A HF', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100044, 10044, '0244A0665', 'HRC 200A SIZE I', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100045, 10045, '0244A0844', 'POWER CONTRACTORS 3 POLE AC CONTROL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100046, 10046, '0244A0858', 'CONTACTOR: 300 AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 7, 0, 0, 0, 0),
(100047, 10047, '0244A0928', 'CONTACTOR MNX45, 110V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 12, 0, 0, 0, 0),
(100048, 10048, '0244A0958', 'SIEMENS CONTACTOR,110VAC,3TF3200-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 6, 0, 0, 0, 0),
(100049, 10049, '0244A0960', 'SIEMENS CONTACTOR,415VAC,3TF3400-OARO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100050, 10050, '0244A0961', 'SlEMENS CONTACTOR,220VAC,3TF3400-OAMO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100051, 10051, '0244A0962', 'ACTUATOR,2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 6, 0, 0, 0, 0),
(100052, 10052, '0244A0964', 'SIEMENS CONTACTOR,220VAC,3TF4822-OAPO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100053, 10053, '0244A0965', 'SIEMENS CONTACTOR,110VAC,3TF4822-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100054, 10054, '0244A0968', 'SIEMENS CONTACTOR,110VAC,3TF5202-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 14, 0, 0, 0, 0),
(100055, 10055, '0244A0969', 'SIEMENS CONTACTOR,110VAC,3TF5600-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100056, 10056, '0244A0973', 'SIEMENS CONTACTOR,110VAC,3TF3010-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100057, 10057, '0244A0976', 'SIEMENS CONTACTOR,110VAC,3TH3022-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100058, 10058, '0244A1002', 'SIEMENS CONTACTOR,10A,110V,3TF3010-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100059, 10059, '0244A1005', 'SIEMENS CONTACTOR,16A,110V,3TF3110-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100060, 10060, '0244A1074', 'SIEMENS CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100061, 10061, '0244A1140', 'VACUUM CONTACTOR 820A 220V AC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100062, 10062, '0244F0093', 'POWER CONTACTOR 420 AMPS.WITH 110 VOLTS', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100063, 10063, '0248A0021', 'CONTACT, ELECTRICAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100064, 10064, '0248A0117', 'ADD ON BLOCK FOR D2 & F RANGE CONTACTORS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100065, 10065, '0248A0249', 'CONTACT KIT FOR 3 TF 50', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100066, 10066, '0248A0253', 'CONTACT SET FOR 3TF54', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4, 0, 0, 0, 0),
(100067, 10067, '0255A0654', '0CCB', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100068, 10068, '0256A0128', 'MCB,2 POLE,16AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100069, 10069, '0256A0131', 'MCB,2 POLE,32AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100070, 10070, '0256A0132', 'MCB,2 POLE,40AMPS C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100071, 10071, '0256A0215', 'MERLIN GERIN MCB 1POLE 2A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100072, 10072, '0256A0218', 'MERLIN GERIN MCB 1POLE 6A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100073, 10073, '0256A0220', 'MERLIN GERIN MCB 1POLE 16A C CURVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100074, 10074, '0256A0288', 'MERLIN GERIN RCBO 16A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100075, 10075, '0256A0290', 'MERLIN GERIN RCBO 25A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100076, 10076, '0256A0291', 'MERLIN GERIN RCBO 32A C CURVE - 2 POLE 3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100077, 10077, '0256A1517', '550A 3 POLE POWER CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100078, 10078, '0256A1529', '200AMPS MCCB WITH ROTARY HANDLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100079, 10079, '0257L0084', 'OIL SEAL, 52 MM, 40 MM, 7 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100080, 10080, '0274A0102', 'SPLIT PIN FOR VI MECHANISM OF LF', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100081, 10081, '0278A0025', 'DOOR FITTINGS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 10, 0, 0, 0, 0),
(100082, 10082, '0289A0067', 'CO GAS DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100083, 10083, '0291B0022', 'POWDER CLEANING', '', 'LIT', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 22, 0, 0, 0, 0),
(100084, 10084, '0291D0018', 'MISCELLANEOUS ITEMS (Godrej LOCK 8 lever', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100085, 10085, '0344A0007', 'CONDENSER FOR POWER CIRCUITS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100086, 10086, '0356A0054', '\"MCB DISTRIBUTION BOARD,12 WAY WITH WIRI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 3, 0, 0, 0, 0),
(100087, 10087, '0358A0032', 'PLUG FOR ELECT. POWER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100088, 10088, '0358A0083', 'METAL CLAD PLUG 20A 3 P', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 166, 0, 0, 0, 0),
(100089, 10089, '0359A0016', 'HIGH POWER LED TORCH LIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 30, 0, 0, 0, 0),
(100090, 10090, '0362A0743', 'HALOGEN LAMP 500W', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 13, 0, 0, 0, 0),
(100091, 10091, '0365a0002', 'CALLING BELL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100092, 10092, '0367A0155', '160 WATT PROGRAMMABLE HOOTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 11, 0, 0, 0, 0),
(100093, 10093, '0380B0038', '\"LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100094, 10094, '0380B0038', 'LIMIT SWITCH,2NO+2NC,20A,H/D,STYLE AB/7', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100095, 10095, '0394A0058', 'ALUMINIUM FOIL TAPE SIZE 5 CM X 10 MTR.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 972, 0, 0, 0, 0),
(100096, 10096, '0401D0096', 'PRESSURE TRANSMITTER, 0 - 10 BAR FOR CO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100097, 10097, '0426A0254', 'PERISTALTIC PUMP / 2 /12000 ML / H', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100098, 10098, '0426D0048', 'CONDENSATE MONITOR,MAT.PVC,CONNECTION-', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100099, 10099, '0435a0004', 'BAR SOAP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 500, 0, 0, 0, 0),
(100100, 10100, '0439A0074', 'HYDRAULIC OPERATED HAND PALLET TROLLY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 3, 0, 0, 0, 0),
(100101, 10101, '0445A0128', '1.5 SQMM GREY CONTROL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100102, 10102, '0447A0856', '3Cx10 sq. mm 1.1 KV XLPE AL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100103, 10103, '0447A0859', '3Cx70 sq. mm 1.1 KV XLPE AL CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100104, 10104, '0447A0897', '3C X 300SQMM 1.1KV ALU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100105, 10105, '0449A0018', 'CABLES,CONTROL FOR FIXED WIRING', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100106, 10106, '0449A0126', 'SINGLE CORE COPPER FLEXIBLE CABLE,1.5SQ', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100107, 10107, '0449A0381', 'CNTRL CABLE 2.5X4C 1KV CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100108, 10108, '0449A0381', 'CTRL CABLE,2.5X4CX1KV,CU,HRE,HRE SH,ARM', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100109, 10109, '0449A0384', 'CTRL CBL,1KV, CU,2.5X4C,SIL,GLS BRAID', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100110, 10110, '0449A0832', '24CX1.5 SQMM 1.1KVXLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100111, 10111, '0449A0834', '16Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100112, 10112, '0449A0838', '7Cx1.5 SQ.MM 1.1KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100113, 10113, '0449A0840', '4Cx2.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100114, 10114, '0449A0841', '4Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100115, 10115, '0449A0842', '3Cx2.5 SQ.MM 1.1KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100116, 10116, '0449A0842', '3Cx2.5sq. mm 1.1 KV XLPE AL CABLE', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100117, 10117, '0449A0843', '3Cx1.5sq. mm 1.1 KV XLPE CU CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100118, 10118, '0451B0027', 'HYD.HOSE ASSLY SWAGED   4MM    1/4BSP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100119, 10119, '0453A0049', 'CABLE FOR CABLE REELING DRUM,70 SQ.MM.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100120, 10120, '0453A0192', 'FLEXIBLE HT CABLE FOR 6.6KV', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100121, 10121, '0470A0610', 'PAD Locking Kit for E Stop switch', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 6, 0, 0, 0, 0),
(100122, 10122, '0479A0059', 'CTS 1500A CT & TOCB ABB DRIVE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100123, 10123, '0485A0256', '\"ELECTRONIC DIGITAL MOTOR PROTECTION REL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100124, 10124, '0485A0396', 'ELECTRONIC OVERCURRENT RELAY EOCR 3DM60', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100125, 10125, '0485A0455', 'MOELLER DC CONTROL RELAY 24VDC 2NO 2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100126, 10126, '0485A0456', 'MOELLER AC CONTROL RELAY 110VAC 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100127, 10127, '0485A0689', 'BOCR  - 3 DE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100128, 10128, '0485A1038', '0.5-60A SAMWHA EOCR-3DM2WRDUW', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100129, 10129, '0485A1040', '0.5-60A EOCR Type FMZ2WRDUW with E/F', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100130, 10130, '0486A2447', '7.5KW Motor for Hoist', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100131, 10131, '0486A4060', 'SPL MOTR;SCIM,SEW EURO DRIVE,4 KW', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100132, 10132, '0517A0072', 'SWITCH,PROXIMITY - NO TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 6, 0, 0, 0, 0),
(100133, 10133, '0530A0112', 'STRIPPEX HT TAPE HIGH TEMP. TAPE 25MMX0.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100134, 10134, '0530A0139', 'NO FIRE A - 18 IN 1 LTR.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100135, 10135, '0530A0161', 'SILICO SEAL : ( 7.25 OZ PACK)', '', 'BOT', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 15, 0, 0, 0, 0),
(100136, 10136, '0530B0053', 'PRISM 406 for O-ring', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100137, 10137, '0535A0115', '\"THERMOMETER BULB DIA 6MM, 8MM, 10MM, 12', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100138, 10138, '0535A0474', 'TRUE-RMS METER FOR PRECISE MEASUREMENT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100139, 10139, '0546A1974', 'Drill M/C IFM  M 12 connector(EVC009)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100140, 10140, '0546G0037', 'SS TYPE 5 PIN PLUG 30A 500V FOR TEMP.MEA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100141, 10141, '0546P0073', 'INSTRUMENTATION SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100142, 10142, '0556A0144', '16 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100143, 10143, '0556A0145', '25 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100144, 10144, '0556A0146', '50 SQ MM,CU FLATE SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100145, 10145, '0556A0995', 'COPPER SOCKET  (XLPE)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100146, 10146, '0556A0996', 'COPPER SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100147, 10147, '0556A1023', 'COPPER SOCKET HEAVY DUTY 50 SQ.MM.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100148, 10148, '0556A1035', 'SOCKET FOR CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100149, 10149, '0556A1036', 'PIN SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100150, 10150, '0556A1038', 'PIN SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 79, 0, 0, 0, 0),
(100151, 10151, '0556A1045', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 98, 0, 0, 0, 0),
(100152, 10152, '0556A1047', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 70, 0, 0, 0, 0),
(100153, 10153, '0556A1049', 'RING SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100154, 10154, '0556A1069', 'COPPER SOCKET (XLPE) 70MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100155, 10155, '0556A1070', 'CU.SOCKET 95 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 186, 0, 0, 0, 0),
(100156, 10156, '0556A1071', 'CU. RING SOCKET50 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 49, 0, 0, 0, 0),
(100157, 10157, '0556A1073', 'CU.RING SOCKET 70 MM.SQ.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 45, 0, 0, 0, 0),
(100158, 10158, '0565B0058', 'BRAKE SHOE COMPT.WITH LINING FOR 8\"DIA', '', 'PAA', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100159, 10159, '0579A1264', 'Polyuretane foam (PUF) seal', '', 'ML', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100160, 10160, '0579A1287', 'Solvent based cleaner Light duty Spray', '', 'ml', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100161, 10161, '0622A0898', 'PNEUMATIC HOSE 12.07.X 5 METER 20 KG.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100162, 10162, '0633A0104', 'CABLE TIE 100X2.5', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4600, 0, 0, 0, 0),
(100163, 10163, '0633A0105', 'TIE 188X4.8', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100164, 10164, '0633A0106', 'CABLE TIE 370X4.8', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100165, 10165, '0666A0079', 'TRANSFORMER OIL,E.H.V,AS PER IS:335,AL', '', 'LTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100166, 10166, '0782A0938', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100167, 10167, '0782A0939', 'M.I.CABLE, 4 CORE CELOX, TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100168, 10168, '0782A1332', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100169, 10169, '0782A1348', 'M.I.CABLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100170, 10170, '0814A0005', 'BRAKE SHOE WITH LINING FOR 10\" DIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100171, 10171, '0814A0006', 'BRAKE SHOE WITH LINING FOR 13\" DIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100172, 10172, '0829A0093', 'HAND LEVER OPERATED GREASE GUN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100173, 10173, '0829A0095', 'VOLUME PUMP 10 KG FOR MANUAL LUBRICATION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100174, 10174, '0843A0003', 'REGULATOR FOR CEILING FAN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 16, 0, 0, 0, 0),
(100175, 10175, '0850A0012', 'PLICA CONDUIT 3/4\"LEAD COATED,HEAT & C', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100176, 10176, '0850A0013', 'PLICA CONDUIT 1\" LEAD COATED,HEAT & CO', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100177, 10177, '0853A0082', 'SWITCH & CIRCUIT BREAKER ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100178, 10178, '0853A0388', '2 32AMPS HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100179, 10179, '0853A0468', '2 HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100180, 10180, '0853A0471', 'ACTUATOR NORMAL(RED)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100181, 10181, '0853A0496', 'COIL FOR 3TF56 CONTACTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100182, 10182, '0853a0526', 'ACTUATOR,1NO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100183, 10183, '0853A0527', 'SIEMENS CONTACTOR,110VAC,3TF3400-OAFO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100184, 10184, '0853A0542', 'AUX.BLOCK WITH 2NO+2NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 8, 0, 0, 0, 0),
(100185, 10185, '0853A0594', ' PENDANT CONTROL STATION, MAKE: TELEMECA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100186, 10186, '0853A0684', '5PAK 100 US WITH 2N/O+2NC WITH 110V AC C', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100187, 10187, '0853O0028', 'SILICA GEL SOLID GLOSSY RTS 741', '', 'KG', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100188, 10188, '0858A0636', 'LOAD CELL 25 TON', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100189, 10189, '0870A0746', 'HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100190, 10190, '0870A0747', 'HP laserjet 305A Printer cartridge.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100191, 10191, '0870A0748', 'HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100192, 10192, '0870A0749', ' HP laserjet 305A Printer cartridge', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100193, 10193, '0877A0124', 'HRC FUSE SIZE 0,2AMPS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 30, 0, 0, 0, 0),
(100194, 10194, '0877A0330', 'HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 224, 0, 0, 0, 0),
(100195, 10195, '0877A0332', 'HRC FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100196, 10196, '0877A0333', 'HRC FUSE SIZE 0.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100197, 10197, '0877A0336', 'HRC FUSE SIZE 0.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 46, 0, 0, 0, 0),
(100198, 10198, '0877A0342', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 47, 0, 0, 0, 0),
(100199, 10199, '0877A0343', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 31, 0, 0, 0, 0),
(100200, 10200, '0877A0344', 'HRC FUSE SIZE 1.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100201, 10201, '0877A0463', '16 A  HRC FUSE BS TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 33, 0, 0, 0, 0),
(100202, 10202, '0877A0500', 'HRC FUSE 2 AMPERES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 60, 0, 0, 0, 0),
(100203, 10203, '0877A0737', 'HF FUSE 10A,SF90148,L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 120, 0, 0, 0, 0),
(100204, 10204, '0877A0738', 'HF FUSE 20 AMP SF90151 L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 18, 0, 0, 0, 0),
(100205, 10205, '0877A0739', 'HF FUSE 25A,SF90152,L&T', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 30, 0, 0, 0, 0),
(100206, 10206, '0877B0037', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 50, 0, 0, 0, 0),
(100207, 10207, '0877B0041', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 35, 0, 0, 0, 0),
(100208, 10208, '0877B0043', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100209, 10209, '0877B0046', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100210, 10210, '0877B0049', 'FUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100211, 10211, '0910A1488', 'INPUT SHAFT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100212, 10212, '0910A2026', 'LT DRIVE OUTPUT SHAFT', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100213, 10213, '0929A0011', 'SEALANT TAPE  12MT. PER ROLL', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 168, 0, 0, 0, 0),
(100214, 10214, '0936A0107', 'PLUG & SOCKET BOARD 220V 20A SPN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 7, 0, 0, 0, 0),
(100215, 10215, '0936A0207', 'MOUNTING CHANNEL FOR ELEMEX,MCB.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100216, 10216, '0936A0279', '63 AMP DS PLUG AND SOCKET ,BOX MOUNTED', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100217, 10217, '0937A0039', 'CONTROL CABLE FOR INSTRUMENTATION-4 PAIR  0.8MM ', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100218, 10218, '0940A0015', 'CABLES FOR FESTOONING(4 SQ.MM.,1100 VOLT,4 CORE,FLEXIBLE)', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100219, 10219, '0940A0056', 'FESTOONING CABLE,10X3C,1KV,CU,EPR,CSP SH', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100220, 10220, '0940A0057', 'FESTOONING CABLE,6X3CX1KV,CU,EPR,CSP SH', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100221, 10221, '0940A0102', 'FESTOON CABLE,SCREENED, 4C X 2.5 SQ.MM', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100222, 10222, '0940A0103', 'CABLE,FLEX,Cu,PVC,2.5SQ.,MM X 4C, LAPP', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100223, 10223, '0940A0103', 'FLEX CABLE CU PVC 4CX2.5SQMM LAPP CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100224, 10224, '0954A0007', 'ELECTRODE 6013 MILD STEEL 4 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100225, 10225, '0954A0008', 'WELDING ELECT MILD STEEL 3.15 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100226, 10226, '0954A0009', 'WELDING ELECT MILD STEEL 2.5 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100227, 10227, '0954A0011', 'ELECTRODE 7018 LOW HYDROGEN 4 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100228, 10228, '0954A0012', 'WELDING ELECT LOW HYDROGEN 3.15 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100229, 10229, '0954A0013', 'ELECTRODE,AWS 7018,MEDIUM CARBON,2.5 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100230, 10230, '0957A0074', 'DURACELL PLUS AAA ALKALINE 1.5V BATTERY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 14, 0, 0, 0, 0),
(100231, 10231, '0957A0119', 'SIZE AA PENCIL CELL,1.5V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 297, 0, 0, 0, 0),
(100232, 10232, '0958A0848', 'DURACELL PLUS, AA SIZE, 1.5 V.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 105, 0, 0, 0, 0),
(100233, 10233, '0959A0295', 'BATTERY GRADE SULPHURIC ACID', '', 'LTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100234, 10234, '0960a0094', 'BATTERY CHARGER, 2 NOS FLOAT CUM BOOST', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100235, 10235, '0983A0176', 'AXIAL FLOW FAN', '', 'nOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100236, 10236, '0996A0058', 'FR Jacket E3 grade-Small', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 18, 0, 0, 0, 0),
(100237, 10237, '0996A0059', 'FR Jacket E3 grade- Medium', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 10, 0, 0, 0, 0),
(100238, 10238, '0996A0060', 'FR Jacket E3 grade- Large', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 19, 0, 0, 0, 0),
(100239, 10239, '0996A0061', 'FR Jacket E3 grade- Ex Large', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100240, 10240, '0996A0062', 'FR Trouser E3 grade- Small', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100241, 10241, '0996A0063', 'FR Trouser E3 grade- Medium', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100242, 10242, '0996A0064', 'FR Trouser E3 grade-Large', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100243, 10243, '0996A0065', 'FR Trouser E3 grade- Ex Large', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100244, 10244, '0999A0333', '150 WATT METAL HALIDE LAMP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100245, 10245, '1041A4636', 'SP4 570A 1400V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100246, 10246, '1041A4723', 'RCNA-01 CONTROL NET ADAPTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100247, 10247, '1041A5472', 'Analogue I/O 16 chan', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100248, 10248, '1041A5482', 'DO module,8 channel, 24V DC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100249, 10249, '1047A1419', 'BUS CONNECTOR FOR PROFIBUS PG 12 MBIT/S', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100250, 10250, '1048A0216', 'RIGHT END CAP TERMINAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100251, 10251, '1072A0555', 'USB 3-I THRUSTER DISC BRAKE 400x30-50/6', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100252, 10252, '1072A1160', '19 inch brake liner', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100253, 10253, '1106A0005', '\"LIGHTING CONNECTOR       ,SIZE : 0.5  T', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1102, 0, 0, 0, 0),
(100254, 10254, '1106A0038', '0.08 TO 4 MM SQUARE SCREWLESS TERMINAL B', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 700, 0, 0, 0, 0),
(100255, 10255, '1138A0024', 'LIGHTING TRANSFORMER,25 KVA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100256, 10256, '1142A0259', 'MNX400 CONTACTOR CS94144', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 7, 0, 0, 0, 0),
(100257, 10257, '1142A0265', 'MNX110 CONTACTOR CS94137', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100258, 10258, '1156A0083', 'XD2PA22 ONE NOTCH 2 DIRECTION JOYSTICK', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100259, 10259, '1304A0613', '48 Port Switch', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100260, 10260, '1306A0288', 'S.Sleeve,40.0 mm shaft X 9.91 mm wide', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100261, 10261, '1306A0329', 'S.Sleeve,110.0 mm shaft X 12.93 mm wide', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100262, 10262, '1586A1068', 'Control Net Redundant Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100263, 10263, '1586A1069', 'EhterNet/IP Communication Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100264, 10264, '1586A1224', '24V DC, 8A POWER SUPPLY MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100265, 10265, '1586A1251', 'PROFIBUS CONNECTOR WITHOUT PG:', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100266, 10266, '1586A1533', 'Redundancy Module', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100267, 10267, '1615A0422', 'RG-6 Co-axial Cable.(Video Cable)', '', 'mtr', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100268, 10268, '1877A0048', 'CV6 COIL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100269, 10269, '1877A0324', 'GLAND PACKING-M/C-52NE7581', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100270, 10270, '1877A1181', 'OIL LEAKAGE KIT -(Common New)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100271, 10271, '1889A1390', 'POWER SUPPLY MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100272, 10272, '1889A1393', 'DIGITAL INPUT MODULE 32 DI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100273, 10273, '1889A1396', 'BUSTERMINAL FOR PROFIBUS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100274, 10274, '1889A1407', 'RELAY COUPLE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100275, 10275, '1889A1409', 'VALVE CONNECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100276, 10276, '1889A1413', 'POWER SUPPLY DC - SITOP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100277, 10277, '1889A1416', 'MAINS FILTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100278, 10278, '1889A1419', 'IND. PROXIMITY SWITCH', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100279, 10279, '2442A0022', 'PORTABLE HAND BLOWER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100280, 10280, '2746A0072', '4 core trailing cable for B-type T/C', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100281, 10281, '2746A0112', 'MODBUS CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100282, 10282, '3178A0113', 'SIMATIC NET, PROFIBUS OLM/G12 V4.0', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100283, 10283, '3178A0132', 'EhterNet/IP Communication Bridge Module', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100284, 10284, '3285A0023', 'CABIN FAN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100285, 10285, '5010A0252', 'SPHRICAL ROLLR BRG,22230 CC/W33,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100286, 10286, '5010A0332', 'SPHRICAL ROLLR BRG,23136 CCW33,STRAIGHT,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100287, 10287, '5010A0429', 'SPHRICAL ROLLR BRG;22334CCW33,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100288, 10288, '5010A0588', '24124CC/W33,STRAIGHT,120MM,200MM,80MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100289, 10289, '5013A0268', 'TAPER ROLLR BRG;33209,45MM,85MM,32MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100290, 10290, '5013A0322', 'TAPER ROLLR BRG', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100291, 10291, '5014A0090', 'EL SWCH;32A,1,DP SWITCH,HDP,230-250V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100292, 10292, '5036A0868', 'BEARING;SL 182928 ,NORMAL ,STEEL ,140 MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100293, 10293, '5176A0052', 'WLKY TLKY SPR;PTT KEYPAD,MOTOROLA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100294, 10294, '5176A0091', 'BATTERY ,KENWOOD ,KNB 57L ,WALKIE TALKIE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100295, 10295, '5189A0018', 'ELECTRONIC INST,TESTNG & MSRNG,ELECTRIC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100296, 10296, '5189A0089', 'EL T&M INST', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100297, 10297, '5276A0028', 'SFTWR;KEPWARE,KEPWARE MODBUS OPC SUITE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100298, 10298, '5288A0049', 'SFTY SHOE;10IN,BLACK', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100299, 10299, '5288A0050', 'SFTY SHOE;9,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100300, 10300, '5288A0055', 'SFTY SHOE;8IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100301, 10301, '5288A0056', 'SFTY SHOE;7IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4, 0, 0, 0, 0),
(100302, 10302, '5288A0057', 'SFTY SHOE;6IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 3, 0, 0, 0, 0),
(100303, 10303, '5288A0065', 'SFTY SHOE;5IN,BLACK,INSULATED STEEL TOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100304, 10304, '5309A1110', 'FRMC OVL ICU SXGA+ ,BARCO NOS,LARGE VIDE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100305, 10305, '5309A1112', 'UN OVL ENGINE Y T3 ,BARCO NOS,LARGE VIDE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100306, 10306, '5309A1452', 'SPEAKERPHONE  ,SENNHEISER  ,LAPTOP  ,HP/', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100307, 10307, '5309A1749', '32\" CURVE TFT ,HP ,DISPLAY MONITOR ,HP ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100308, 10308, '5309A1855', 'WIRELESS BLUETOOTH HEADPHONE  ,BOAT  ,LA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100309, 10309, '5320A0776', 'OIL SEAL;HIGH NITRILE RUBBER,45MM,62MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100310, 10310, '5320A1316', 'OIL SEAL;NBR ,140 MM,170 MM,12 MM,120 Â°C', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100311, 10311, '5322A0042', 'WIRELESS GTWY;ANTENNA ,USIT ,USIT-ASL-10', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100312, 10312, '5322A0067', 'WIRELESS GTWY;RF DATA TRANSMISSION ,PHOE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100313, 10313, '5355A0003', '11KV ELECT INSULATING MAT', '', 'ROLL', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100314, 10314, '5362A0028', 'PT;33/v3 KV,110/V3V,1,CAST RESIN,INDOOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100315, 10315, '5378A0005', 'O-RING CORD,NBR,5.7MM,72SHORE A,120Â¬C,NO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100316, 10316, '5387A0001', 'PRSE KNT HND GL;8', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100317, 10317, '5387A0002', 'PRSE KNT HND GL;Knitted hand gloves 12\"', '', 'PAA', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100318, 10318, '5434A0068', 'PAINT;PAINTING,ENAMEL,RED,4L TIN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100319, 10319, '5434A0070', 'PAINT;PAINTING,ENAMEL,GOLDEN YELLOW', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100320, 10320, '5437A0012', 'SWTCH NTWRK;1000MBPS,24NOS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100321, 10321, '5455A0580', 'HYD. HAND PUMP WITH PRE. GAUGE  ,ENERPAC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100322, 10322, '5483A0040', 'INSLTG TPE;ADHESIVE PVC  ,1.1  KV,GREEN', '', 'nOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 291, 0, 0, 0, 0),
(100323, 10323, '5490A0241', 'WEGHNG M/C ACC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100324, 10324, '5495A0160', 'CNTRLR;MASTER CONTROLLER,220VAC,DIGITAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100325, 10325, '5502A0271', 'CPLNG SPR,SPIDER,L225,LOVEJOY,FLEXIBLE,N', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100326, 10326, '5507A0023', 'BRAKE;160MM,ELECTROMAGNETIC,DRUM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100327, 10327, '5507A0038', 'BRAKE;150MM,ELECTROMAGNETIC,DRUM', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100328, 10328, '5508A0110', 'ENCODER;HOLLOW SHAFT INC ENCODER,KUBLER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100329, 10329, '5509A0316', 'MCCB;32A,3,415V,50KA,AC,50HZ,1NO+1NC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100330, 10330, '5512A0090', 'SPR LOAD CEL;SARTORIUS,PR 6201/15N', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100331, 10331, '5513A0010', '7 SEG DSPLY;LED,RED,4,RED,100MM,190MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100332, 10332, '5521A0322', 'BRAKE SHOE WITH LINER ,SIBRE ,SIBRE ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100333, 10333, '5523A0094', 'FAN;CABIN,AC,1,230V,WALL,50HZ,400MM,4', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100334, 10334, '5523A0145', 'FAN;HEAVY DUTY AXIAL FLOW FAN ,AC ,SINGL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100335, 10335, '5527A0014', 'FLXBL CNDUIT,2\",PVC,FLEXIBLE,NO ACCESSOR', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100336, 10336, '5531A0257', 'CRANE ACCES,CURRENT COLLECTOR,ESI,CI-9,G', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100337, 10337, '5531A0293', 'CRANE ACCES;CARBON BRUSH,VAHLE,102980', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100338, 10338, '5531A0448', 'OPERATOR CHAIR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100339, 10339, '5531A0791', 'CRANE DSL INSULATOR  ,VAHLE  ,VDB 45 PHA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100340, 10340, '5539A0029', 'BAT CHRGR;SMF,FLOAT CUM BOOST,NO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100341, 10341, '5540A0328', 'ELECTRONIC CARD PLC PROFIBUS CABLE SEIMENS', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100342, 10342, '5542A0100', 'DRV SPR,FAN,ABB,64650424,ABB DRIVE,ABB,D', '', 'nOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100343, 10343, '5542A0280', 'DRV SPR;PULSE COUNTER,ABB,RTAC-01', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100344, 10344, '5542A1157', 'DRIV SPR;CONTROL UNIT CU 310 2 DP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100345, 10345, '5542A2070', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100346, 10346, '5542A2097', 'MAIN CONTACTOR  ,SIEMENS  ,SIMOVERT MAST', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100347, 10347, '5542A2761', 'COOLING FAN ,SCHNEIDER ,ATV71HC28N4 ,VZ3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 7, 0, 0, 0, 0),
(100348, 10348, '5544A2381', 'BOLT ;HEX HEAD,10MM,30MM,80,SS304', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100349, 10349, '5544A3661', 'BOLT:HEX HEAD 20, MM, 150 MM, SS304', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100350, 10350, '5553A0260', 'CAPACITOR;POLYPROPYLENE,6ÂµF,415V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100351, 10351, '5554A0039', 'LNGT TRF;50 KVA,5% IN 2.5% STEP ,ANAN ,F', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100352, 10352, '5555A0062', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,230 V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100353, 10353, '5555A0071', 'CNV SFTY SW;BELT SWAY SWITCH ,10 A,240 V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100354, 10354, '5557A0037', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC-', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100355, 10355, '5558A0035', 'HYD JACK;50TON,150MM,SINGLE ACTING', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100356, 10356, '5563A0915', 'SPARE;COPPER DISC,LADLE FURNACE,LD1', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100357, 10357, '5566A0059', 'CCTV CAM;5MP', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100358, 10358, '5575A0069', 'RCBO;25 A,4 ,415 V,300 MA,C ,50 HZ,50 Â°C', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100359, 10359, '5582A0014', 'VCB;1250A,3,36000V,DRAW OUT TYPE,SHUNT', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100360, 10360, '5582A0039', 'VCB;1250 A,3 ,6600 V,DRAW OUT TYPE ,50 H', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100361, 10361, '5593A0077', 'TEMP TRNTR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100362, 10362, '5593A0099', 'TEMP TRNTR;2 WIRE TEMPERATURE TRANSMITTE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100363, 10363, '5607A0666', 'RELAY;ELECTROMECHANICAL,CONTROL CIRCUIT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100364, 10364, '5607A0671', 'RELAY;ELECTRONIC,IR MEASUREMENT,+/-1%', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100365, 10365, '5607A1125', 'RELAY;ELECTRONIC OVERCURRENT RELAY ,MOTO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100366, 10366, '5607A1297', 'RELAY;ELECTROMAGNETIC ,MAGNET UNDERCURRE', '', 'nOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100367, 10367, '5613A0186', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100368, 10368, '5613A0187', 'LMT SWTCH;CAM OPERATED,EXTRA HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100369, 10369, '5613A0245', 'LMT SWTCH;SNAP ACTION,HEAVY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100370, 10370, '5620A0226', 'PLC SPR,EN RUSB CARD KIT DRIVEWINDOW 2.3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `v_stock_base` (`skid`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `sts`, `sti`, `sto`, `tri`, `tro`, `adi`, `ado`, `scp`, `rsv`, `isr`) VALUES
(100371, 10371, '5620A0719', 'PLC SPR,PRBS KIT ULTRA PRO WTH OPC SRV,P', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100372, 10372, '5620A0987', 'PLC SPR;ANALOG INPUT MODULE,SIEMENS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100373, 10373, '5620A1046', 'PLC SPR;ANALOG INPUT MODULE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100374, 10374, '5620A1051', 'PLC SPR;REDUNDANCY MODULE,ALLEN BRADLEY', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100375, 10375, '5620A2359', 'ETHERNET MODULE ,CONTROL LOGIX ,1756-EN2', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100376, 10376, '5620A2360', 'CONTROLNET MODULE ,CONTROL LOGIX ,1756-C', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100377, 10377, '5620A2361', 'REDUNDANCY MODULE ,CONTROL LOGIX ,1756-R', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100378, 10378, '5620A2859', 'HMI DISPLAY UNIT ,IBA ,91.000032 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100379, 10379, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN B', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100380, 10380, '5620A3204', 'CONTROLLOGIX REDUNDANCY MODULE ,ALLEN BR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100381, 10381, '5620A4261', 'IBARACKLINE SAS, XEON E, WIN10 ,IBA ,40.', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100382, 10382, '5623A0361', 'MOTOR&ACCES;FIELD COIL,ABB', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100383, 10383, '5623A0787', 'TACHO WITH OVER SPEED ,HUBNER-GERMANY ,F', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100384, 10384, '5623A1254', 'BRAKE UNIT ,NORD ,BRE150 HL ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100385, 10385, '5631A0004', 'INST CLNG FAN,AC,230V,250MM,50 HZ,115 W', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100386, 10386, '5633A0007', 'RGD CNDUIT,1-1/2INCH,GI,HEAT & CORROSION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100387, 10387, '5641A0160', 'SLCTR SW;6 A,10 WAY 3POSITION STAYPUT ,1', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100388, 10388, '5641a0198', 'selector switch', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100389, 10389, '5641A0198', 'SLCTR SW;10 A,4 POSITION SELECTOR WITH O', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100390, 10390, '5669A0400', 'LFT SPR;INVRTR TKE-1-18.5 7.5KW OL/CL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100391, 10391, '5669A0983', 'DOOR SENSOR (IR SCREEN) ,THYSSENKRUPP ,L', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100392, 10392, '5669A1591', 'THIMBLE ROD ,OTIS ,LIFT ,OTIS ELEVATORS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100393, 10393, '5669A1661', '41 TYPE LOCK RH[NOA6694B2] ,OTIS ,LIFT ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100394, 10394, '5669A1991', 'DOOR WIRE CORD ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100395, 10395, '5669A2015', 'CAR GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100396, 10396, '5669A2016', 'CWT GUIDE SHOE ,OTIS ,LIFT ,OTIS ELEVATO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100397, 10397, '5681A0070', 'LIFTNG SHKL;12.5 TON,8 ,35.5 mm', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100398, 10398, '5684A0072', 'SPL LGHT;EMERGENCY,YES,PORTABLE,220VAC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100399, 10399, '5684A0190', 'SPL LGHT;RECHARGEABLE EMERGENCY LAMP ,YE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100400, 10400, '5694A0470', 'NO SPECIAL FEATURES ,CUTTING DISC ,BOSCH', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100401, 10401, '5700A0854', 'FLD SNSR;OPTICAL DISTANCE SENSOR(LASER)', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100402, 10402, '5700A0946', 'FLD SNSR;Vibration Sensor ,BENTALY NAVAD', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100403, 10403, '5701A0088', 'ELECT SOCKT/PLG;32A,METALLIC,5,PLUG', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100404, 10404, '5701A0093', 'ELECT SOCKT/PLG;125A,METALLIC,5,PLUG', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 22, 0, 0, 0, 0),
(100405, 10405, '5701A0095', 'ELECT SOCKT/PLG;32A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100406, 10406, '5701A0096', 'ELECT SOCKT/PLG;63A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4, 0, 0, 0, 0),
(100407, 10407, '5701A0097', 'ELECT SOCKT/PLG;125A,METALLIC,5,SOCKET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100408, 10408, '5701A0100', 'ELECT SOCKT/PLG;63A', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100409, 10409, '5701A0141', 'EL SKT/PLG;20A,METAL CLAD,3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100410, 10410, '5701A0142', 'EL SKT/PLG;20A,METAL CLAD,2,SOCKET,230V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100411, 10411, '5715A0462', 'OMEGA 904  ,MAGNA  ,OMEGA 904  ,5  LITER', '', 'LIT', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100412, 10412, '5715A0599', 'SEAL LEAK PROOF OIL ,OMEGA ,OMEGA 917 ,5', '', 'LIT', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100413, 10413, '5717A0048', 'LT CABLE 16CX2.5MMSQ TINNED COPPER ELASTOMER', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100414, 10414, '5717A0366', 'LT CABLE 12CX2.5SQMM TINNED COPPER', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100415, 10415, '5717A0467', 'LT CBL;6,6MM2,COPPER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100416, 10416, '5717A0910', 'LT CBL;8 ,PVC-ST2-FRLSH ,ANNEALED BARE C', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100417, 10417, '5717A1002', 'LT CBL;2 ,CSP-FRLSH ,ANNEALED TINNED COP', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100418, 10418, '5717A1014', 'LT CBL;4 ,CSP-FRLSH ,ANNEALED TINNED COP', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100419, 10419, '5739A0008', 'TIMER;ELECTRONIC MULTIMODE TIMER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100420, 10420, '5748A0181', 'FUSE,FLUKE MULTIMETER FUSE,440MA,1000V,3', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4, 0, 0, 0, 0),
(100421, 10421, '5748A0609', 'FUSE;HRC,400A,500V,120KA,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 25, 0, 0, 0, 0),
(100422, 10422, '5748A0730', 'FUSE;SEMICONDUCTOR,1100A,1000V,100KA,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100423, 10423, '5751A0049', 'ALCOHOL RUBIN STERILE HAND DIS ,500 ML,N', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100424, 10424, '5761A0136', 'ELECT BOX;JUNCTION BOX,UP TO 1.1KV,WALL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100425, 10425, '5761A0316', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100426, 10426, '5761A0317', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100427, 10427, '5761A0318', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100428, 10428, '5761A0319', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100429, 10429, '5761A0320', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100430, 10430, '5761A0321', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100431, 10431, '5761A0322', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100432, 10432, '5761A0323', 'EL BOX;GROUNDING POINT REQUIRE ,JUNCTION', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100433, 10433, '5761A0326', 'EL BOX;GROUNDING POINT NOT REQUIRE ,JUNC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100434, 10434, '5772A0143', 'PUSH BTN;PB STATION ,GREEN ,TEKNIC ,FLUS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100435, 10435, '5772A0144', 'PUSH BTN;FLUSH MOUNTED P.B ,GREEN ,TEKNI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100436, 10436, '5772A0185', 'PUSH BTN;PUSH BUTTON ACTUATOR ,GREEN ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100437, 10437, '5772A0310', 'PUSH BTN;PUSH BUTTON ACTUATOR ,BLUE ,TEK', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100438, 10438, '5775A0005', 'LV HAND GLOVES;9 ,', '', 'PAA', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100439, 10439, '5789A0075', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 3, 0, 0, 0, 0),
(100440, 10440, '5789A0076', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100441, 10441, '5789A0077', 'OFFC ACCS;RAIN COAT SHIRT AND PAINT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100442, 10442, '5789A0102', 'OFFC ACCS;WIRELESS MOUSE {HP X3500}', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100443, 10443, '5789A0192', 'UMBRELLA WITH WOODEN HANDLE ,ANY ,UMBREL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 4, 0, 0, 0, 0),
(100444, 10444, '5794A0309', 'CBL SCKT;PIN,1.5MM2,COPPER,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100445, 10445, '5794A0310', 'CBL SCKT;PIN,2.5MM2,COPPER,STRAIGHT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100446, 10446, '5803A1238', 'SPL HOSE;HYDRAULIC HOSE 6\" LONG ,HC7206', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100447, 10447, '5811A1619', 'GEAR COUPLING 2 ,LD#1 ,CRANE ,AS PER DRA', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100448, 10448, '5811A2507', 'CRANE SHAFT ,LD#1 ,CRANE ,AS PER DRAWING', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100449, 10449, '5811A3304', 'HG 1050 INPUT PINION SHAFT  ,LD#1  ,BOF', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100450, 10450, '5811A4473', 'HG 1050 2ND INTERMEDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100451, 10451, '5811A4474', 'HG 1050 2ND GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100452, 10452, '5811A4475', 'HG 1050 1ST GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100453, 10453, '5811A4476', 'HG 1050 1ST INTERMEDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100454, 10454, '5811A4477', 'HG 1050 INPUT PINION SHAFT ,LD1 ,VESSEL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100455, 10455, '5811A4486', 'HG 1050 3RD INTERMIDIATE PINIO ,LD1 ,VES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100456, 10456, '5811A4487', 'HG 1050 3RD GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100457, 10457, '5811A4497', 'HG 1050 4TH GEAR ,LD1 ,VESSEL ,AS PER DR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100458, 10458, '5811A4675', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100459, 10459, '5811A4676', 'COPPER SEALING WITH O RINGS ,LD1 ,LF ,AS', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100460, 10460, '5845A0109', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100461, 10461, '5845A0112', 'INSLT TUB;FLAME RETARDANT SLEEVE ,FIBER', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100462, 10462, '5847A0306', 'WIRE ROPE;28 MM,RHO ,1770 N/MM2,150 M RO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100463, 10463, '5847a0340', 'WIRE ROPE;22 MM,RHO ,1770 N/MM2,100 M RO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100464, 10464, '5847a0351', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100465, 10465, '5848A0002', 'POWR TESTR;HT POWER TESTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100466, 10466, '5849A0049', 'CNDTR;CU-AL BIMETALLIC SHEET ,COPPER CLA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100467, 10467, '5854A0035', 'SAFE;FIRE RETARDANT,XXXL,ORANGE,BLUE,NA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100468, 10468, '5859A0004', 'INSULATING MATL,TAPE,TOUGARD,10MX5CM,0,P', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100469, 10469, '5859A0120', 'INSULATING MATL,SHEET,FIBRE INSULATOR,73', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100470, 10470, '5859A0298', 'INSULATING MATL;TAPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100471, 10471, '5859A0315', 'INSULATING MATL;SLEEVE', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100472, 10472, '5867A0345', 'CRBN BRS;EG14 ,VINAYAK CARBON ,CARBON BR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100473, 10473, '5870A1809', 'MATL PROJCT;Spike BusterSET', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100474, 10474, '5872A0113', 'SW GR&CB SPR,CONTACT KIT,BCH,CONTACTOR,9', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100475, 10475, '5872A0418', 'SW GR&CB SPR,AUX CONTACT,ABB,CONTACTOR,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100476, 10476, '5872A1298', 'SW GR&CB SPR,PANEL KEY,PRECISION SPARES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100477, 10477, '5872A1709', 'SW GR&CB SPR,PAD LOCKING KIT,SCNEDR ELEC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100478, 10478, '5872A2046', 'S/GR SPR;MECH ASMBLY OF VAC INTERRUPTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100479, 10479, '5872A2047', 'S/GR SPR;VACCUM INTERRUPTER (BOTTLE)', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100480, 10480, '5872A2197', 'CLOSE CASTING PENDANT ,SMS CONCAST ,MOUL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100481, 10481, '5872A2273', 'DC CONTACT TIP FIXED ,NA ,900 A GE TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100482, 10482, '5872A2279', 'SURGE PROTECTION DEVICE( 24 ,DEHN ,OPACI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100483, 10483, '5872A2283', 'DC CONTACT TIP MOVING ,GE ,900 A GE TYPE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100484, 10484, '5885A0282', 'PROXIMITY;ANALOG PROXIMITY SWITCH,0-4MM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100485, 10485, '5885A0289', 'PROXMTY;INDUCTIVE SENSOR,20MM,10-30V', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100486, 10486, '5885A0326', 'PROXMTY;INDUCTIVE,4MM,10-30V,IP68', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100487, 10487, '5890A0715', 'CONTCR;110A,3,110V,POWER,415V,S6,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100488, 10488, '5890A0723', 'CONTCR;140A,3,110V,POWER,415V,S6,AC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100489, 10489, '5890a0734', 'CONTCOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100490, 10490, '5890A0854', 'CONTCR;70A,3,110V,POWER,415V,8,AC,50HZ', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100491, 10491, '5890A0969', 'CNTCR;900 A,1 ,220 V,DC ,660 V,DC ,2NO+2', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100492, 10492, '5890A1027', 'CNTCR;20 A,2 NOS,240 VAC,DC ,415 V,SIZE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100493, 10493, '5890A1070', 'CNTCR;300 A,3 ,220 V,POWER ,415 V,S10 ,A', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100494, 10494, '5893A0420', 'CONTACT PAD COPPER RING ,PRECISION SPARE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100495, 10495, '5899A0046', 'HAND  WASING PASTE', '', 'kg', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100496, 10496, '5899A0069', 'AUTOMATIC SOAP DISPENSER  ,NA  ,NOT APPL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100497, 10497, '5900A2144', 'AC MOTR;0.18 KW,415 Â± 10% V,SQUIRREL CAG', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100498, 10498, '5900A3424', 'AC MOTR;IE2 ,0.25 KW,415 Â± 10% V,SQUIRRE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100499, 10499, '5900A3570', 'AC MOTR;IE2 ,7.5 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100500, 10500, '5900A3653', 'AC MOTR;IE2 ,3.7 KW,415 Â± 10% V,SQUIRREL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100501, 10501, '5900A3927', 'AC MOTR;IE2 ,7.5 KW,390 +10%/-10% V,SQUI', '', 'nOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100502, 10502, '5905A0003', 'P ISLN;POSITIVE ISO PAD LOCK YELLOW', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100503, 10503, '5914A0169', 'SHOE POLISH,STANDARD,HEAVY METAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100504, 10504, '5918A1049', 'GRINDING MACHINE ,DEWALT ,DW801-B1 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100505, 10505, '5924A0116', 'SPL MOTR;LINEAR ACTUATOR FOR CC1', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100506, 10506, '5924A0268', 'SPL MOTR;CIRCULATION PUMP ,BEACON WEIR L', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100507, 10507, '5924A0278', 'SPL MOTR;AC EVAPORATOR MOTOR ,DOCON ,DC', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100508, 10508, '5924A0378', 'SPL MOTR;0.23 KW 2800 RPM UNBLCE MOTOR ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100509, 10509, '5924A0636', 'SPL MOTR;STOPPER MECHANISM COMPLETE ,SMS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100510, 10510, '5924A0681', 'SPL MOTR;HYDRAULIC PUMP MOTOR ,SIEMENS ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100511, 10511, '5929A0003', 'BRAK MTR;BRAKE MOTORS,0.37KW', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100512, 10512, '5929A0046', 'BRAK MOTR;CARRIAGE MOTOR ,1.1 KW,SMS CON', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100513, 10513, '5953A0075', 'FIVE SLOT CABLE PROTECTOR UNIT,STANDARD', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100514, 10514, '5956A0522', 'INST SPR;MOULD LEVEL DETECTOR CC2/CC3', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100515, 10515, '5956A0633', 'INST SPR;VIBRATION SENSOR VERTICAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100516, 10516, '5956A0634', 'INST SPR;VIBRATION SENSOR HORIZONTAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100517, 10517, '5956A0680', 'INST SPR;Contact Block for temp S 2 Co', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100518, 10518, '5956A0929', 'INST SPR;SIGNAL ISOLATOR,MASIBUS', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100519, 10519, '5956A0930', 'INST SPR;CONTACT BLOCK FOR TEMP B 2 COR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 30, 0, 0, 0, 0),
(100520, 10520, '5956A1492', 'INST SPR TEMP & OXY MEASUREMENT PROBEF', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100521, 10521, '5956A2043', 'SCINTILLATION COUNTER ,BERTHOLD TECHNOLO', '', 'SET', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100522, 10522, '5958A0019', 'CONT BLK;ELECTRICAL PANEL,TEKNIC,NO,1', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100523, 10523, '5964A0171', 'PNL;WELDING MACHINE SAFETY PANEL ,450X44', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100524, 10524, '5964a0196', 'PNL;RIO PANEL ,NO SPECIAL FEATURES ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100525, 10525, '5964A0209', 'PNL;CONTROL DESK WITHOUT HMI ,NO SPECIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100526, 10526, '5965A1903', 'BENCH GRINDER NOS,STGB 3715 ,STANLEY ,1/', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100527, 10527, '5968A0022', 'SPARE,ELECTRONIC;VGA TO HDMI CONVERTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100528, 10528, '5968A0023', 'SPARE,ELECTRONIC;HDMI Cable', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100529, 10529, '5971A0237', 'EPOXY BASED PROTECTIVE COATING ,LOCTITE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100530, 10530, '5995a0026', 'RAD ACT INST;CO-60 ROD SOURCE ,GAMMA RAY', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100531, 10531, '5995A0027', 'RAD ACT INST;SHIELDING FOR AMLC SOURCE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100532, 10532, '5997a0035', 'CONTROL STOP INDICATION SYSTEM ,BALAJI E', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100533, 10533, '6008A0002', 'N/W PASSIVE DEVICE FO CABLE', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100534, 10534, '6010A0001', 'N/W PASSIVE HDPE PIPE/DWC DUCT', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100535, 10535, '6015A0001', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100536, 10536, '6015A0002', 'N/W TRANSRECEIVER FIBER MODULE;CISCO', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100537, 10537, '6021A0056', 'EL TSTG INST;CONTACT RESISTANCE MEASUREM', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100538, 10538, '6024A0040', 'HIGH TEMPERATURE ADHESIVE TAPE ,50 MM,SA', '', 'RLL', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100539, 10539, '6028A0061', 'POWER DISTRIBUTION ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100540, 10540, '6028A0062', 'POWER DISTRIBUTION ACCESSORIES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 1, 0, 0, 0, 0),
(100541, 10541, '6045A0002', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100542, 10542, '6045A0028', 'SPL CBL;CABLE FOR MOULD LEVEL DETECTOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100543, 10543, '6045A0136', 'SPL CBL;CABLES FOR SERVO MOTOR ,LAPP IND', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100544, 10544, '6045A0143', 'SPL CBL;RESOLVER CABLE FOR STOPPER BOX ,', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100545, 10545, '6045A0157', 'SPL CBL;ENCODER CONNECTOR WITH CABLE ,KU', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100546, 10546, '6049A0066', 'SPL INST;TEMPERATURE STICKER ,TEMPERATUR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100547, 10547, '6093A0007', 'LUMR;HIGHBAY,160W,AC,140 - 270V,NO,YES', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100548, 10548, '6093A0014', 'LUMR;WELL GLASS,29W,AC,140 - 270V,NO', '', 'Nos.', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100549, 10549, '6122A0082', 'CABLE ACCESSORIES;450  V,TYPE:U1K16  ,TE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100550, 10550, '6125A0054', 'THZ WAVE RADAR LEVEL TRANSMITT ,PRIBUSIN', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100551, 10551, '6125A0058', 'SPD_230V SINGLE PHASE ,DEHN ,900351 ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100552, 10552, '6128A0018', 'LARGE DIGITAL INDICATOR ,MASIBUS ,409-4I', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100553, 10553, '6130A0017', 'TEMPERATURE & HUMIDITY DISPLAY ,CASIO ,I', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100554, 10554, '6131A0024', 'DISPLAY FOR MAG FLOW ,YOKOGAWA ,F9802JA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100555, 10555, '6132A0805', 'SPARE VALVE STAND FOR HOOD PRS ,SATYATEK', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100556, 10556, '6142A0003', 'STP;KRAMER ,NOT APPLICABLE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100557, 10557, '6183A0009', 'MASTER CONTROLLER;220 VAC,10 A,4-0-4 ,BI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100558, 10558, '6183A0017', 'MASTER CONTROLLER;400 VAC/DC,16 A,4-0-4', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100559, 10559, '6183A0039', 'MASTER CONTROLLER;400 VAC/DC,10 A,1-0-1', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100560, 10560, '6186A0037', 'NW SPARES;LSZH PATCH CORD CAT6A , 10 M', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100561, 10561, '6186A0076', 'NW SPARES;WS-C3850X-12S-E CATALYST 3850X', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100562, 10562, '6186A0273', 'NW SPARES;6U WALL MOUNT NETWORK RACK WIT', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100563, 10563, '6186A0279', 'NW SPARES;6U FLOOR MOUNT OUTDOOR CABINE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100564, 10564, '6186A0297', 'NW SPARES;12 PORT LOADED FIBER LIU RACK', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 5, 0, 0, 0, 0),
(100565, 10565, '6186A0301', 'NW SPARES;FIBER OPTIC CABLE (6 CORE) MM', '', 'M', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100566, 10566, '6186A0310', 'NW SPARES;6 CORE SM FO CABLE,LOOSE TUBE', '', 'MTR', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100567, 10567, '6186A0317', 'NW SPARES;LC-SC FO PATCH CORD, DUPLEX, O', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100568, 10568, '6186A0326', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 2', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100569, 10569, '6186A0327', 'NW SPARES;CAT-6 UTP PATCH CORD LSZH - 15', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100570, 10570, '6186A0328', 'NW SPARES;CAT 6A S/FTP CABLE (500 METER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100571, 10571, '6186A0331', 'NW SPARES;CAT6A STP PATCH CRD 2M LSZH ,N', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100572, 10572, '6186A0357', 'NW SPARES;SC PIGTAIL MM OM1 SIMPLEX LSZH', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100573, 10573, '6186A0359', 'NW SPARES;PATCH CRD;FIBER MULTIMODE DUPL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100574, 10574, '6186A0370', 'NW SPARES;SWITCH ,WS-C2960CX-8TC-L ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 2, 0, 0, 0, 0),
(100575, 10575, '6186A0371', 'NW SPARES;FIREWALL ,FORTIGATE 60E ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100576, 10576, '6204A0001', 'SHUNT FOR CONTACTOR;300 A,BRAIDED WIRE ,', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100577, 10577, '5669A0441', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100578, 10578, '5669A0983', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100579, 10579, '5669A0566', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100580, 10580, '5669A1521', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100581, 10581, '5669A0895', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100582, 10582, '5669A1519', 'LD1E_LF1_CRITICAL_EQUIPMENT_SPARE-5/5', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100583, 10583, '5900A1468', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100584, 10584, '5900A1505', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100585, 10585, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100586, 10586, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100587, 10587, '5900A0971', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100588, 10588, '5900A1469', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100589, 10589, '5900A0885', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100590, 10590, '5900A1387', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100591, 10591, '5900A1088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100592, 10592, '5900A1289', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100593, 10593, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100594, 10594, '5490A0362', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100595, 10595, '5555A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100596, 10596, '5555A0070', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100597, 10597, '5485A0022', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE1/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100598, 10598, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100599, 10599, '0367A0101', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100600, 10600, '5508A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100601, 10601, '5508A0224', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100602, 10602, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100603, 10603, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100604, 10604, '5717A0555', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100605, 10605, '5717A0554', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100606, 10606, '5717A0526', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100607, 10607, '5262A0257/5262A0194/', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100608, 10608, '5552A0372', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100609, 10609, '5924A0134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100610, 10610, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100611, 10611, '5929A0013/5929A0014', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100612, 10612, '5650A0202', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100613, 10613, '5900A1282', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100614, 10614, '5900A1652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100615, 10615, '5508A0192/1043A0389', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100616, 10616, '5929A0027', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100617, 10617, '1156A0041/5495A0106', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100618, 10618, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100619, 10619, '5495A0195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100620, 10620, '1586A0393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100621, 10621, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100622, 10622, '0244A0497', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100623, 10623, '5607Y0038', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100624, 10624, '5607A0153', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100625, 10625, '5607A0477 /5890A0539', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100626, 10626, '5607A1484', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100627, 10627, '1304A0203/5620A1939', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100628, 10628, '5620A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100629, 10629, '5620A0869', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100630, 10630, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100631, 10631, '0858A0451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100632, 10632, '6098A0138', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100633, 10633, '5900A1285', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100634, 10634, '5625A0257', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100635, 10635, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100636, 10636, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100637, 10637, '5620A1687', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100638, 10638, '1304A0200/5620A0873', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100639, 10639, '5870A2846', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE2/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100640, 10640, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100641, 10641, '5512A0054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100642, 10642, '5717A0556', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100643, 10643, '5761A0089/5490A0214', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100644, 10644, '5490A0205', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100645, 10645, '5512A0059', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100646, 10646, '5924A0135', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100647, 10647, '5495A0160/0249A0223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100648, 10648, '6183A0039', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100649, 10649, '5701A0091', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100650, 10650, '5701A0094', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100651, 10651, '5701A0008', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100652, 10652, '5701A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100653, 10653, '5701A0088', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100654, 10654, '5701A0095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100655, 10655, '5701A0092', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100656, 10656, '5701A0096', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100657, 10657, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100658, 10658, '5946A0328', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100659, 10659, '5657A0031', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100660, 10660, '0244A0962', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100661, 10661, '0244A0965', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100662, 10662, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100663, 10663, '5900A1449', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100664, 10664, '5900A1501', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100665, 10665, '5566A0079', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100666, 10666, '0453A0123', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100667, 10667, '5625A0252', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100668, 10668, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100669, 10669, '1156A0041/5495A010', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE3/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100670, 10670, '5497A0453', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100671, 10671, '0853A1693', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100672, 10672, '5890A0729', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100673, 10673, '5890A0674/5890A0455', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100674, 10674, '5890A1178', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100675, 10675, '5890A0510/5890A0756', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100676, 10676, '0256A2624', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100677, 10677, '5739A0071', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100678, 10678, '0244A1084', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100679, 10679, '5620A0948', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100680, 10680, '5620A1054', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100681, 10681, '5620A1053', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100682, 10682, '5620A2167', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100683, 10683, '5620A2393', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100684, 10684, '0711A1034', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100685, 10685, '5536A0013', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100686, 10686, '5900A1068', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100687, 10687, '5900A3223', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100688, 10688, '5900Y0056', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100689, 10689, '5507A0016', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100690, 10690, '5900A1665', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100691, 10691, '5507A0020', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100692, 10692, '5542A1531', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100693, 10693, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100694, 10694, '5900A2625', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100695, 10695, '5552A0315', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100696, 10696, '5620A0949', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100697, 10697, '5620A2334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100698, 10698, '5620A1051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100699, 10699, '5620A0166', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100700, 10700, '5620A1046', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100701, 10701, '5620A1052', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100702, 10702, '5620A1045', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100703, 10703, '5620A1043', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100704, 10704, '5620A2400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100705, 10705, '5552A0334', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE4/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100706, 10706, '5669A0006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100707, 10707, '5669A0400', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100708, 10708, '5669A0414', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100709, 10709, '5669A0397', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100710, 10710, '5669A0100', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100711, 10711, '5669A0411', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100712, 10712, '5669A0009', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100713, 10713, '5669A0984', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100714, 10714, '1629A0055', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100715, 10715, '0546A4280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100716, 10716, '1430A0273', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100717, 10717, '0961A0250', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100718, 10718, '5625A0269', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100719, 10719, '0545A0308', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `v_stock_base` (`skid`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `sts`, `sti`, `sto`, `tri`, `tro`, `adi`, `ado`, `scp`, `rsv`, `isr`) VALUES
(100720, 10720, '5900A1485', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100721, 10721, '5924A0681', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100722, 10722, '5900A1176', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE5/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100723, 10723, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100724, 10724, '0244A0829', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100725, 10725, '5900A1364', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100726, 10726, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100727, 10727, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100728, 10728, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100729, 10729, '5900A1195', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100730, 10730, '5521A0345', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100731, 10731, '5900A0991', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100732, 10732, '5900A1098', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100733, 10733, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100734, 10734, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100735, 10735, '5900A1093', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100736, 10736, '5900A0973', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100737, 10737, '5900A1342', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100738, 10738, '5900A1147', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE6/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100739, 10739, '5607A0051', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100740, 10740, '5900A1006', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100741, 10741, '0380A0448', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100742, 10742, '5648A0155', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE7/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100743, 10743, '5510A0007', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100744, 10744, '1041A2940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100745, 10745, '1047A1795', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100746, 10746, '5542A0907', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100747, 10747, '5581A0003', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100748, 10748, '0380A0622', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100749, 10749, '5542A1509', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100750, 10750, '5542A0280', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100751, 10751, '5620A1095', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100752, 10752, '5542A0940', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100753, 10753, '5542A0753', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100754, 10754, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100755, 10755, '5542A0908', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100756, 10756, '0255A0639', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE8/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100757, 10757, '5900A1519', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100758, 10758, '5536A0012', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100759, 10759, '5900A1134', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100760, 10760, '5900A1395', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100761, 10761, '5900Y0019', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100762, 10762, '5900A2601', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100763, 10763, '5900Y0402', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100764, 10764, '5490A0281', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100765, 10765, '5521A0404', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100766, 10766, '5900A1978', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100767, 10767, '5894A0713', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100768, 10768, '1586A0663', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100769, 10769, '5542A1688', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100770, 10770, '1041A2427', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100771, 10771, '5542A1503', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100772, 10772, '1586A0648', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100773, 10773, '1586A0652', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100774, 10774, '5900A1451', 'LD1E_VSL_MHS_CRITICAL_EQUIP_SPARE9/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100775, 10775, '5625A0113', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100776, 10776, '5648A0121', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100777, 10777, '1043A0155', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100778, 10778, '5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100779, 10779, '3274A0019/5592A0056', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100780, 10780, '5968A0102', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100781, 10781, '5778A3492', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100782, 10782, '1329A0139', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE10/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100783, 10783, '5900A0965', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100784, 10784, '5900A0913', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100785, 10785, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100786, 10786, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100787, 10787, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100788, 10788, '5900A2786', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100789, 10789, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100790, 10790, '5900A1176', 'LD1EVSL_MHS_CRITICAL_EQUIP_SPARE11/11', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100791, 10791, '5872A2035 ', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100792, 10792, '5885A0326', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100793, 10793, '5924A0102', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100794, 10794, '5557A0037', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100795, 10795, '5924A0074', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100796, 10796, '5924A0116', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100797, 10797, '5929A0008', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100798, 10798, '6045A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100799, 10799, '5956A0521', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100800, 10800, '5929A0002', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100801, 10801, '6098A0167/5625A0327', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100802, 10802, '5900A1091', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100803, 10803, '5924A0081', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100804, 10804, '5924A0083', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100805, 10805, '5924A0082', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100806, 10806, '5924A0102', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100807, 10807, '5540A1233 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100808, 10808, '5620A1877 ', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100809, 10809, '6045A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100810, 10810, '6045A0002', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100811, 10811, '5956A0522', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE1/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100812, 10812, '6045A0001', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100813, 10813, '6045A0002', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100814, 10814, '5717A0690', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100815, 10815, '5717A0518', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100816, 10816, '5717A0517', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100817, 10817, '6045A0172', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100818, 10818, '5717A0699', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-1/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100819, 10819, '6045A0136', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100820, 10820, '6045A0146', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100821, 10821, '6045A0143', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100822, 10822, '5924A0173', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100823, 10823, '5924A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100824, 10824, '5924A0171', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100825, 10825, '5613A0187', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100826, 10826, '5613A0186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100827, 10827, '5924A0164', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100828, 10828, '5613A0245', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100829, 10829, '5929A0009', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100830, 10830, '5625A0325', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100831, 10831, '5924A0118', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100832, 10832, '5924A0142', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100833, 10833, '5523A0001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100834, 10834, '5924A0119', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100835, 10835, '5508A0140', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100836, 10836, '5872A2035', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100837, 10837, '5924A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100838, 10838, '5045A0008', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100839, 10839, '5924A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE2/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100840, 10840, '5700A0852', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100841, 10841, '5620A2284', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100842, 10842, '5508A0269', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100843, 10843, '5540A1431', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100844, 10844, '5540A1432', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100845, 10845, '5540A1370', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100846, 10846, '5540A1368', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100847, 10847, '5540A1233', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100848, 10848, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100849, 10849, '5542A0932', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100850, 10850, '5620A0409', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100851, 10851, '5542A1218', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100852, 10852, '5557A0037', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100853, 10853, '5700A0853', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100854, 10854, '5700A0869', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100855, 10855, '5700A0870', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100856, 10856, '5700A0871', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-2/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100857, 10857, '6045A0145', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100858, 10858, '5508A0249', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100859, 10859, '5700A0854', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100860, 10860, '5924A0317', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100861, 10861, '5872A2197', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100862, 10862, '5924A0316', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100863, 10863, '5924A0318', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100864, 10864, '5540A1370', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100865, 10865, '5540A1368', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100866, 10866, '5924A0283', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100867, 10867, '5900A1208', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100868, 10868, '5885A0289', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100869, 10869, '5613A0187', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100870, 10870, '5613A0186', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100871, 10871, '6098A0168', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100872, 10872, '5929A0003', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100873, 10873, '5924A0077', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100874, 10874, '5507A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100875, 10875, '5507A0036', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100876, 10876, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100877, 10877, '5924A0123', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100878, 10878, '5625A0430', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100879, 10879, '5900A1968', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE3/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100880, 10880, '5520A0435', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100881, 10881, '5495A0123', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100882, 10882, '5872A2035 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100883, 10883, '6183A0015', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100884, 10884, '5964A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100885, 10885, '0958A1983', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-3/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100886, 10886, '5540A1431', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100887, 10887, '5700A0882', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100888, 10888, '5717A0518', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100889, 10889, '6045A0189', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100890, 10890, '5717A0699', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100891, 10891, '6098A0125', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100892, 10892, '5717A0517', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100893, 10893, '5717A0690', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100894, 10894, '5542A0014', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100895, 10895, '6045A0172', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100896, 10896, '5090A0029', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100897, 10897, '5717A0699', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100898, 10898, '6045A0172', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100899, 10899, '5717A0517', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100900, 10900, '5717A0690', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100901, 10901, '5557A0037', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100902, 10902, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100903, 10903, '5900A3450', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100904, 10904, '5924A0074', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100905, 10905, '5900A2021', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100906, 10906, '5900A2026', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100907, 10907, '5900A1229', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE4/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100908, 10908, '5924A0081', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100909, 10909, '5924A0083', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100910, 10910, '5924A0102', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100911, 10911, '5924A0082', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100912, 10912, '5924A0079', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100913, 10913, '5929A0003', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100914, 10914, '5924A0111', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100915, 10915, '5929A0012', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100916, 10916, '5924A0125', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100917, 10917, '5924A0213', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100918, 10918, '5924A0216', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100919, 10919, '5924A0215', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100920, 10920, '5924A0077', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100921, 10921, '5929A0004', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100922, 10922, '5924A0074', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100923, 10923, '5900A1091', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-4/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100924, 10924, '0958A1983', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100925, 10925, '5495A0205', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100926, 10926, '5508A0319', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100927, 10927, '5520A0434', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100928, 10928, '5924A0636', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100929, 10929, '5956A0990', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100930, 10930, '5872A2054', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100931, 10931, '5273A0273', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100932, 10932, '5964A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100933, 10933, '5613A0359', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100934, 10934, '5625A0326', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100935, 10935, '5700A0854', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100936, 10936, '5607A0666', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100937, 10937, '5620A1667', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100938, 10938, '5620A1768', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100939, 10939, '5620A1787', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100940, 10940, '5620A2521', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100941, 10941, '5620A1788', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100942, 10942, '5620A1773', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100943, 10943, '5620A1314', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100944, 10944, '5620A2566', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE5/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100945, 10945, '5956A0522', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100946, 10946, '5885A0289', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100947, 10947, '5613A0186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100948, 10948, '5613A0187', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100949, 10949, '5700A0812', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100950, 10950, '5700A0854', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100951, 10951, '5700A0881', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100952, 10952, '5700A0882', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100953, 10953, '5700A0885', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100954, 10954, '6045A0189', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100955, 10955, '5956A0990', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100956, 10956, '6045A0191', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100957, 10957, '5872A2054', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-5/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100958, 10958, '1043A0439', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100959, 10959, '5580A1885', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100960, 10960, '5964A0142', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100961, 10961, '5620A1686', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100962, 10962, '5620A0362', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100963, 10963, '5620A1753', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100964, 10964, '5620A0463', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100965, 10965, '5620A0491', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100966, 10966, '5620A0436', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100967, 10967, '5918A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100968, 10968, '5900A3800', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100969, 10969, '5700A0017', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100970, 10970, '5620A0250', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100971, 10971, '5620A0497', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100972, 10972, '5620A1183', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE6/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100973, 10973, '5620A2117', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100974, 10974, '5620A1468', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100975, 10975, '5620A0436', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100976, 10976, '5620A0986', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100977, 10977, '5620A1763', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100978, 10978, '5620A0250', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100979, 10979, '5620A0890', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100980, 10980, '5620A2019 ', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100981, 10981, '5620A0532', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100982, 10982, '5620A0873', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100983, 10983, '5620A0987', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-6/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100984, 10984, '5669A0018', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100985, 10985, '5669A0396', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100986, 10986, '5669A0417', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100987, 10987, '5669A0985', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100988, 10988, '5669A0201', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100989, 10989, '5669A0082', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100990, 10990, '5262A0199', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100991, 10991, '5540A0382', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100992, 10992, '5620A2214', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100993, 10993, '5620A1644', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100994, 10994, '5620A2019', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100995, 10995, '5620A2086', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100996, 10996, '5620A1945', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100997, 10997, '5620A1937', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100998, 10998, '5620A2210', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(100999, 10999, '5623A1186', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101000, 11000, '5620A2042', 'LD1E_CC1_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101001, 11001, '6098A0124', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101002, 11002, '6098A0125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101003, 11003, '6183A0050', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101004, 11004, '5540A1233', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101005, 11005, '0517A0421', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101006, 11006, '0517A0422', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101007, 11007, '5700A0885', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101008, 11008, '5508A0942', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101009, 11009, '5580A0941', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101010, 11010, '6098A0533', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE7/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101011, 11011, '5620A2458', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101012, 11012, '5620A1818', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101013, 11013, '5620A0898', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101014, 11014, '5620A0429', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101015, 11015, '5620A2571', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101016, 11016, '5620A1754', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101017, 11017, '5620A1466', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'm', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101018, 11018, '5584A0031', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101019, 11019, '5384A0013', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101020, 11020, '5623A1186', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101021, 11021, '5607A0190', 'LD1E_CC3_CRITICAL_EQUIPMENT_SPARE-7/7', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101022, 11022, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101023, 11023, '0485A0740', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101024, 11024, '5542A1911/ 5620A2393', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101025, 11025, '5620A2351', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101026, 11026, '5620A1045', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101027, 11027, '5620A2334', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101028, 11028, '5620A1927', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101029, 11029, '5620A2426', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101030, 11030, '5620A1821', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101031, 11031, '5620A2879', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101032, 11032, '5900A2794', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101033, 11033, '5900A2001', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101034, 11034, '5900A3910', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE8/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101035, 11035, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101036, 11036, '5900A2832', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101037, 11037, '5900A1922', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101038, 11038, '5900A2125', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101039, 11039, '5900A2145', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101040, 11040, '5900A1298', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101041, 11041, '5900A3995', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101042, 11042, '5900A2750', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101043, 11043, '5900A1322', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101044, 11044, '5900A2103', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101045, 11045, '5900A2059', 'LD1E_CC2_CRITICAL_EQUIPMENT_SPARE9/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101046, 11046, '5507A0103', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101047, 11047, '5507A0104', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101048, 11048, '5885A0036', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101049, 11049, '5047A0088', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101050, 11050, '5872A2035 ', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101051, 11051, '5607A0699', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101052, 11052, '5900A4017', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101053, 11053, '5956A3994', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101054, 11054, '5540A1811', 'LD1ECC2_CRITICAL_EQUIPMENT_SPARE10/10', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101055, 11055, '5956A4131', '2 BY 2', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101056, 11056, '', 'TEST MATERIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 5, 2, 0, 0, 3, 0, 0, 0, 0),
(101057, 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', '', '', 'A', 10, 0, 0, 5, 0, 0, 2, 0, 0),
(101058, 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Vessel', '', '', 'A', 0, 0, 2, 0, 0, 0, 0, 0, 0),
(101059, 11057, '', 'TEST MATERIAL CRIT', '', 'NOS', 'Y', 'Toolkit Store', 'TEST SUB LOC', 'RACK TEST', 'A', 0, 1, 3, 0, 0, 0, 0, 0, 0),
(101060, 11058, '', 'COMPUTER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 5, 0, 0, 0, 10, 0, 0, 0, 0),
(101061, 11059, '', 'KEYBOARD', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 3, 0, 0, 0, 0, 0, 0, 0, 0),
(101062, 11060, '', 'MOUSE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 10, 0, 0, 0, 10, 0, 0, 0, 0),
(101063, 11061, '', 'PROCESSOR', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 16, 13, 0, 0, 0, 0, 0, 0, 0),
(101064, 11062, '9090A1010', 'TEST MATRIAL', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101065, 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', 'CABLE YARD', 'R1-A', 'A', 0, 0, 2, 0, 0, 0, 0, 0, 0),
(101066, 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', 'OUTSIDE STORE', 'R1-B', 'A', 0, 0, 3, 0, 0, 0, 0, 0, 0),
(101067, 11063, '1212A9090', 'BOILER', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 34, 0, 0, 0, 0, 0, 0, 0, 0),
(101068, 10003, '0008A0062', '\"BRG.BALL,SINGLE ROW,DEEP GROOVE,M.6216\"', '', 'NOS', 'N', 'Caster', '', '', 'A', 0, 0, 2, 0, 0, 0, 0, 0, 0),
(101069, 10011, '0093A0119', 'CABLE GLAND  19 MM', '', 'NOS', 'N', 'SMLP', '', '', 'A', 0, 0, 6, 0, 0, 0, 0, 0, 0),
(101070, 10002, '', '3Cx 4 SQ.MM 1.1KV FLEX CU CABLE', '', 'M', 'N', 'Toolkit Store', '9MTR STORE', 'RACK 1', 'A', 0, 0, 2, 0, 0, 0, 0, 0, 0),
(101071, 11064, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101072, 11065, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0),
(101073, 11066, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 2, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `v_stock_base` (`skid`, `itid`, `mtcd`, `material`, `make`, `uom`, `critical`, `loc`, `sloc`, `ssloc`, `sts`, `sti`, `sto`, `tri`, `tro`, `adi`, `ado`, `scp`, `rsv`, `isr`) VALUES
(101074, 11067, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 5, 0, 0, 0, 0, 0, 0, 0, 0),
(101075, 11068, '', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 4, 0, 0, 0, 0, 0, 0, 0, 0),
(101076, 11069, '', 'CIBGI', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 10, 0, 0, 0, 0, 0, 0, 0, 0),
(101077, 11070, '', 'WHAT A JOKE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 20, 0, 0, 0, 10, 0, 0, 0, 0),
(101078, 11071, '', 'HE HE HE HE', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 30, 0, 0, 0, 15, 0, 0, 0, 0),
(101079, 11072, '1001E9090', 'ABCINDIA', '', 'NOS', 'N', 'Toolkit Store', '', '', 'A', 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stock_date_nos`
-- (See below for the actual view)
--
CREATE TABLE `v_stock_date_nos` (
`dt` varchar(10)
,`loc` varchar(40)
,`sti` decimal(32,0)
,`sto` decimal(32,0)
,`stt` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stock_line`
-- (See below for the actual view)
--
CREATE TABLE `v_stock_line` (
`rem` varchar(200)
,`id` double
,`skid` double
,`sl` int(11)
,`itid` int(11)
,`process` varchar(30)
,`bprocess` varchar(30)
,`dfdt` varchar(40)
,`dt` datetime
,`dfcdt` varchar(49)
,`cdt` datetime
,`mtcd` varchar(45)
,`material` varchar(150)
,`make` varchar(40)
,`uom` varchar(30)
,`qty` int(11)
,`loc` varchar(40)
,`sloc` varchar(40)
,`ssloc` varchar(40)
,`tloc` varchar(50)
,`issueto` varchar(50)
,`takenby` varchar(50)
,`tsloc` varchar(500)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stock_summ`
-- (See below for the actual view)
--
CREATE TABLE `v_stock_summ` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_stock_summ_crit`
-- (See below for the actual view)
--
CREATE TABLE `v_stock_summ_crit` (
`itid` int(10)
,`mtcd` varchar(20)
,`material` varchar(200)
,`loc` varchar(40)
,`avl` double
,`sti` double
,`sto` double
,`tri` double
,`tro` double
,`adi` double
,`ado` double
,`scp` double
,`rsv` double
,`isr` double
);

-- --------------------------------------------------------

--
-- Structure for view `v_stock`
--
DROP TABLE IF EXISTS `v_stock`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stock`  AS  select `v_stock_base`.`skid` AS `skid`,`v_stock_base`.`itid` AS `itid`,`v_stock_base`.`sts` AS `sts`,`v_stock_base`.`mtcd` AS `mtcd`,`v_stock_base`.`material` AS `material`,`v_stock_base`.`loc` AS `loc`,`v_stock_base`.`sloc` AS `sloc`,`v_stock_base`.`ssloc` AS `ssloc`,`v_stock_base`.`make` AS `make`,`v_stock_base`.`critical` AS `critical`,`v_stock_base`.`uom` AS `uom`,((((`v_stock_base`.`sti` + `v_stock_base`.`tri`) + `v_stock_base`.`adi`) + `v_stock_base`.`isr`) - ((((`v_stock_base`.`sto` + `v_stock_base`.`tro`) + `v_stock_base`.`ado`) + `v_stock_base`.`scp`) + `v_stock_base`.`rsv`)) AS `avl`,`v_stock_base`.`sti` AS `sti`,`v_stock_base`.`sto` AS `sto`,`v_stock_base`.`tri` AS `tri`,`v_stock_base`.`tro` AS `tro`,`v_stock_base`.`adi` AS `adi`,`v_stock_base`.`ado` AS `ado`,`v_stock_base`.`scp` AS `scp`,`v_stock_base`.`rsv` AS `rsv`,`v_stock_base`.`isr` AS `isr` from `v_stock_base` where (`v_stock_base`.`sts` = 'A') ;

-- --------------------------------------------------------

--
-- Structure for view `v_stock_date_nos`
--
DROP TABLE IF EXISTS `v_stock_date_nos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stock_date_nos`  AS  select distinct left(`x`.`cdt`,10) AS `dt`,`x`.`loc` AS `loc`,ifnull((select sum(`t_stock_process_line`.`qty`) from `t_stock_process_line` where (`t_stock_process_line`.`skid` in (select `t_stock_process`.`id` from `t_stock_process` where (left(`t_stock_process`.`cdt`,10) = left(`x`.`cdt`,10))) and (`t_stock_process_line`.`process` = 'SI'))),0) AS `sti`,ifnull((select sum(`t_stock_process_line`.`qty`) from `t_stock_process_line` where (`t_stock_process_line`.`skid` in (select `t_stock_process`.`id` from `t_stock_process` where (left(`t_stock_process`.`cdt`,10) = left(`x`.`cdt`,10))) and (`t_stock_process_line`.`process` = 'SO'))),0) AS `sto`,ifnull((select sum(`t_stock_process_line`.`qty`) from `t_stock_process_line` where (`t_stock_process_line`.`skid` in (select `t_stock_process`.`id` from `t_stock_process` where (left(`t_stock_process`.`cdt`,10) = left(`x`.`cdt`,10))) and (`t_stock_process_line`.`process` = 'TO'))),0) AS `stt` from `t_stock_process` `x` ;

-- --------------------------------------------------------

--
-- Structure for view `v_stock_line`
--
DROP TABLE IF EXISTS `v_stock_line`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stock_line`  AS  select `s`.`rem` AS `rem`,`s`.`id` AS `id`,`s`.`skid` AS `skid`,`s`.`sl` AS `sl`,`s`.`itid` AS `itid`,`sc`.`process` AS `process`,`s`.`bprocess` AS `bprocess`,date_format(`s`.`dt`,'%d-%b-%Y') AS `dfdt`,`s`.`dt` AS `dt`,date_format(`s`.`cdt`,'%d-%b-%Y %h:%i:%s') AS `dfcdt`,`s`.`cdt` AS `cdt`,`s`.`mtcd` AS `mtcd`,`s`.`material` AS `material`,`s`.`make` AS `make`,`s`.`uom` AS `uom`,`s`.`qty` AS `qty`,`s`.`loc` AS `loc`,`s`.`sloc` AS `sloc`,`s`.`ssloc` AS `ssloc`,`s`.`tloc` AS `tloc`,`s`.`issueto` AS `issueto`,`s`.`takenby` AS `takenby`,(case when ((`s`.`bprocess` = 'InternalMovement') and (`s`.`process` = 'TO')) then (select `sp`.`tosloc` from `t_stock_process_line` `sp` where ((`sp`.`spid` = `s`.`spid`) and (`sp`.`sl` = `s`.`spsl`))) else '' end) AS `tsloc` from (`t_stock` `s` left join `t_stock_process_code` `sc` on((`s`.`process` = `sc`.`code`))) where (`s`.`sts` = 'A') ;

-- --------------------------------------------------------

--
-- Structure for view `v_stock_summ`
--
DROP TABLE IF EXISTS `v_stock_summ`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stock_summ`  AS  select `v`.`itid` AS `itid`,`v`.`mtcd` AS `mtcd`,`v`.`material` AS `material`,`v`.`loc` AS `loc`,`v`.`critical` AS `critical`,`v`.`uom` AS `uom`,sum(`v`.`avl`) AS `avl`,sum(`v`.`sti`) AS `sti`,sum(`v`.`sto`) AS `sto`,sum(`v`.`tri`) AS `tri`,sum(`v`.`tro`) AS `tro`,sum(`v`.`adi`) AS `adi`,sum(`v`.`ado`) AS `ado`,sum(`v`.`scp`) AS `scp`,sum(`v`.`rsv`) AS `rsv`,sum(`v`.`isr`) AS `isr`,`i`.`ittp` AS `ittp`,`i`.`rating` AS `rating`,`i`.`omtcd` AS `omtcd`,`i`.`appl` AS `appl`,`i`.`wlvl` AS `wlvl`,`i`.`rlvl` AS `rlvl` from (`v_stock` `v` left join `t_stock_item` `i` on((`v`.`itid` = `i`.`id`))) group by `v`.`itid`,`v`.`mtcd`,`v`.`material`,`v`.`loc`,`i`.`ittp`,`i`.`rating`,`i`.`omtcd`,`i`.`appl`,`i`.`wlvl`,`i`.`rlvl` ;

-- --------------------------------------------------------

--
-- Structure for view `v_stock_summ_crit`
--
DROP TABLE IF EXISTS `v_stock_summ_crit`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_stock_summ_crit`  AS  select `v_stock`.`itid` AS `itid`,`v_stock`.`mtcd` AS `mtcd`,`v_stock`.`material` AS `material`,`v_stock`.`loc` AS `loc`,sum(`v_stock`.`avl`) AS `avl`,sum(`v_stock`.`sti`) AS `sti`,sum(`v_stock`.`sto`) AS `sto`,sum(`v_stock`.`tri`) AS `tri`,sum(`v_stock`.`tro`) AS `tro`,sum(`v_stock`.`adi`) AS `adi`,sum(`v_stock`.`ado`) AS `ado`,sum(`v_stock`.`scp`) AS `scp`,sum(`v_stock`.`rsv`) AS `rsv`,sum(`v_stock`.`isr`) AS `isr` from `v_stock` where (`v_stock`.`critical` = 'Yes') group by `v_stock`.`itid`,`v_stock`.`mtcd`,`v_stock`.`material`,`v_stock`.`loc` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `t_log_recorded`
--
ALTER TABLE `t_log_recorded`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_process_log`
--
ALTER TABLE `t_process_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock`
--
ALTER TABLE `t_stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `skid` (`skid`,`sl`,`itid`,`mtcd`,`material`,`loc`,`sloc`,`ssloc`,`make`) USING BTREE;

--
-- Indexes for table `t_stock_block`
--
ALTER TABLE `t_stock_block`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_company`
--
ALTER TABLE `t_stock_company`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_department`
--
ALTER TABLE `t_stock_department`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_excel`
--
ALTER TABLE `t_stock_excel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_excel_line`
--
ALTER TABLE `t_stock_excel_line`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `t_stock_location`
--
ALTER TABLE `t_stock_location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material`
--
ALTER TABLE `t_stock_material`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material_application`
--
ALTER TABLE `t_stock_material_application`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material_make`
--
ALTER TABLE `t_stock_material_make`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material_rating`
--
ALTER TABLE `t_stock_material_rating`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material_type`
--
ALTER TABLE `t_stock_material_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_material_uom`
--
ALTER TABLE `t_stock_material_uom`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_out_emp`
--
ALTER TABLE `t_stock_out_emp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_out_emp_issue`
--
ALTER TABLE `t_stock_out_emp_issue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_plant`
--
ALTER TABLE `t_stock_plant`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_process`
--
ALTER TABLE `t_stock_process`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_process_code`
--
ALTER TABLE `t_stock_process_code`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_process_line`
--
ALTER TABLE `t_stock_process_line`
  ADD PRIMARY KEY (`spid`,`sl`) USING BTREE;

--
-- Indexes for table `t_stock_rack`
--
ALTER TABLE `t_stock_rack`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_reorder`
--
ALTER TABLE `t_stock_reorder`
  ADD PRIMARY KEY (`sl`);

--
-- Indexes for table `t_stock_room`
--
ALTER TABLE `t_stock_room`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_stock_sap`
--
ALTER TABLE `t_stock_sap`
  ADD PRIMARY KEY (`sl`);

--
-- Indexes for table `t_user`
--
ALTER TABLE `t_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `v_stock_base`
--
ALTER TABLE `v_stock_base`
  ADD PRIMARY KEY (`skid`) USING BTREE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
