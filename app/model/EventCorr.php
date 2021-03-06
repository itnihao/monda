<?php

namespace App\Model;

use Nette,
    Nette\Utils\Strings,
    Nette\Security\Passwords,
    Nette\Diagnostics\Debugger,
    Nette\Database\Context,
    \ZabbixApi;

/**
 * ItemStat global class
 */
class EventCorr extends Monda {

    function ecSearch($opts) {
        $eq=Array(
            "hostids" => $opts->hostids,
            "time_from" => $opts->start,
            "time_till" => $opts->end,
            "output" => "extend",
            "selectItems" => "refer",
            "selectHosts" => "refer",
            "select_alerts" => "refer",
            "select_acknowledges" => "refer"
        );
        $events=self::apiCmd("eventGet",$eq);
        return($events);
    }
    
    function ecLoi($opts) {
        $events=self::ecSearch($opts);
        CliDebug::warn(sprintf("Need to update loi for %d events.\n",count($events)));
        if (count($events)==0) {
            return;
        }
        self::mbegin();
        foreach ($events as $e) {
            $w=Tw::twSearchClock($e->clock)->fetchAll();
            $wids=self::extractIds($w,array("id"));
            self::mquery("UPDATE timewindow SET loi=loi+? WHERE id IN (?)",$opts->inc_loi_event_window,$wids["id"]);
            foreach ($e->hosts as $h) {
                self::mquery("UPDATE hoststat SET loi=loi+? WHERE hostid=? AND windowid IN (?)",$opts->inc_loi_event_host,$h->hostid,$wids["id"]);
            }
            foreach ($e->items as $i) {
                self::mquery("UPDATE itemstat SET loi=loi+? WHERE hostid=? AND windowid IN (?)",$opts->inc_loi_event_item,$i->itemid,$wids["id"]);
            }
        }
        self::mcommit();
    }

}

?>
