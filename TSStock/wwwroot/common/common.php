<?php

include_once __DIR__ . '/../sql/DBOperation.php';

function getProjectName()
{
    return "Hasnoh Computers Education Management System";
}

function getGRIDClass()
{
    return "class='table HCGrid table-bordered'";
}

function getGRIDClassPlain()
{
    return "class='table table-bordered'";
}

function trapEcho($msg)
{
    $db = new DBOperation();
    
    $msg = str_replace("'", "`", $msg);
    
    $db->DMLExecute("insert into t_testing values(sysdate(),'$msg')");
}

function toDBDate($dt)
{
    if($dt!="")
    {
        $dt = new DateTime($dt); 
        return date_format($dt, "Y-m-d");
    }
    return "";
}

function getUIDate($dy,$invl)
{
    $db = new DBOperation();
    if($dy=="")
        return $db->GenrateRecordset("select date_format(sysdate(),'%d.%m.%Y')")->getData(0,0);
    else
        return $db->GenrateRecordset("select date_format(date_add(sysdate(),INTERVAL " . $dy . " " . $invl . "),'%d.%m.%Y')")->getData(0,0);
}

function toUIDate($dt)
{
    if($dt!="")
    {
        $dt = new DateTime($dt); 
        return date_format($dt, "d-m-Y");
    }
    return "";
}

?>
