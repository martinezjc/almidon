<?php
    if (!$id1) $id1 = $this->request[$this->key1];
    if (!$id2) $id2 = $this->request[$this->key2];
    if ($this->join) {
      $sqlcmd = "SELECT $this->all_fields FROM $this->name " . $this->getJoin() . " WHERE $this->name.$this->key1 = '$id1' AND $this->name.$this->key2 = '$id2'";
    } else
      $sqlcmd = "SELECT $this->fields FROM $this->name WHERE $this->name.$this->key1 = '$id1' AND $this->name.$this->key2 = '$id2'";
    $this->execSql($sqlcmd);
    $row = $this->data->fetchRow(MDB2_FETCHMODE_ASSOC);
    $this->current_record = $row;
