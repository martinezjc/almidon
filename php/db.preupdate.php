<?php
    # FIXME: deberiamos reinicializar 'request', sino puede tomar valores anteriores
    $n = 0;
    $skipped_cols = 0;
    $values = "";
    foreach($this->definition as $column) {
      if ($n > 0 && $column['type'] != 'external' && $column['type'] != 'auto' && $column['type'] != 'order' && $column['type'] != 'serial')
        $values .= ",";
      switch($column['type']) {
      	case 'external':
      	case 'auto':
      	case 'order':
        case 'serial':
          $skipped_cols++;
          $n--;
          break;
        case 'int':
          if (!isset($this->request[$column['name']]) || $this->request[$column['name']] === -1 || $this->request[$column['name']] === '')
            $this->request[$column['name']] = 'NULL';
        case 'smallint':
        case 'numeric':
          $values .= $column['name'] . "=" . $this->request[$column['name']];
          break;
        case 'image':
          if ($nofiles || isset($_REQUEST[$column['name'] . '_keep']) || !isset($this->files[$column['name']]) || empty($this->files[$column['name']]) ) {
            if (!isset($_REQUEST[$column['name'] . '_keep']) && empty($this->files[$column['name']])) {
              $values .= $column['name'] . "=''";
            } else {
              $values .= $column['name'] . "=" . $column['name'];
            }
          } elseif ($this->files[$column['name']]) {
            if (isset($column['extra']['cdn']) && $column['extra']['cdn'] === true) {
              $auth = new CF_Authentication(CDN_USERNAME, CDN_APIKEY);
              $auth->authenticate();
              $conn = new CF_Connection($auth);
              $cloudfiles = $conn->get_container(CDN_REPO);
            }
            $timemark = mktime();
            $filename =  $timemark . "_" . $this->request[$column['name']];
            $value = almdata::escape($filename);
            $values .= $column['name'] . "=" ."'" . $value . "'";
            if (isset($column['extra']['cdn']) && $column['extra']['cdn'] === true) {
              # upload to CDN
              $afile = $cloudfiles->create_object($filename);
              $afile->content_type = mime_content_type($this->files[$column['name']]);
              $afile->load_from_filename($this->files[$column['name']]);
            } else {
              if (!file_exists(ROOTDIR . '/files/' . $this->name)) mkdir(ROOTDIR . '/files/' . $this->name);
              move_uploaded_file($this->files[$column['name']], ROOTDIR . '/files/' . $this->name . '/' . $filename);
            }
            if (isset($column['extra']['sizes']) && defined('PIXDIR'))  $sizes = explode(',',$column['extra']['sizes']);
            if(isset($sizes)) {
              foreach($sizes as $size) {
                if (isset($column['extra']['cdn']) && $column['extra']['cdn'] === true) {
                  # FIXME: get original image from CDN repo
                  #$image = imagecreatefromstring(file_get_contents(CDN_URL.'/'.$filename));
                } else {
                  $image = imagecreatefromstring(file_get_contents(ROOTDIR.'/files/'.$this->name.'/'.$filename));
                }
                list($ancho,$alto) = preg_split('/x/', $size);
                $alto_original = imagesy($image);
                $ancho_original = imagesx($image);
                if (!$alto) $alto = ceil($alto_original*($ancho/$ancho_original));
                $new_image = imagecreatetruecolor ($ancho, $alto);
                imagecopyresampled($new_image, $image, 0, 0, 0, 0, $ancho, $alto, $ancho_original, $alto_original);
                # this code puts the year and month
                $filename = $ancho.($alto?"x$alto":"").'_'.$filename;
                $filepath = PIXDIR.'/'.date("Y",$timemark).'/'.date("m",$timemark).'/';
                if(file_exists($filepath) || mkdir($filepath, null, true))
                  imagejpeg($new_image, $filepath.'/'.$filename,72);
                if (isset($column['extra']['cdn']) && $column['extra']['cdn'] === true) {
                   # upload to CDN, remove from local fs
                   $afile = $cloudfiles->create_object($filepath.'/'.$filename);
                   $afile->content_type = mime_content_type($this->files[$column['name']]);
                   $afile->load_from_filename($this->files[$column['name']]);
                   unlink($filepath.'/'.$filename);
                }
              }
            }
          }
          break;
        case 'file':
          #if ($nofiles) break;
          if ($nofiles || $_REQUEST[$column['name'] . '_keep'] || !$this->files[$column['name']]) {
            if (!$_REQUEST[$column['name'] . '_keep'] && !$this->files[$column['name']])
              $values .= $column['name'] . "=''";
            else
              $values .= $column['name'] . "=" . $column['name'];
          } elseif ($this->files[$column['name']]) {
            $filename =  mktime() . "_" . $this->request[$column['name']];
            if (!file_exists(ROOTDIR . '/files/' . $this->name)) mkdir(ROOTDIR . '/files/' . $this->name);
            move_uploaded_file($this->files[$column['name']], ROOTDIR . '/files/' . $this->name . '/' . $filename);
            $value = almdata::escape($filename);
            $values .= $column['name'] . "=" ."'" . $value . "'";
          }
          break;
        case 'char':
          if ($this->request[$column['name']] == -1) {
            $this->request[$column['name']] = 'NULL';
            $values .= $column['name'] . "=" . $this->request[$column['name']];
          } else {
            $value = almdata::escape($this->request[$column['name']]);
            $values .= $column['name'] . "=" ."'" . $value . "'";
          }
          break;
        case 'varchar':
          if (!isset($this->request[$column['name']]) || $this->request[$column['name']] == -1) {
            $this->request[$column['name']] = 'NULL';
            $values .= $column['name'] . "=" . $this->request[$column['name']];
          } else {
            $value = ($this->escaped) ? $this->request[$column['name']] : almdata::escape($this->request[$column['name']]);
            $values .= $column['name'] . "=" ."'" . $value . "'";
          }
          break;
        case 'text':
          if (isset($this->request[$column['name']])) {
            $value = ($this->escaped) ? $this->request[$column['name']] : almdata::escape($this->request[$column['name']]);
            $values .= $column['name'] . "=" ."'" . $value . "'";
          } else {
            $values .= $column['name'] . "=NULL";
          }
          break;
        case 'bool':
        case 'boolean':
          $value = (isset($this->request[$column['name']])) ? $this->request[$column['name']] : '0';
          $value = (!$value || $value == 'false' || $value == '0') ? '0' : '1';
          $values .= $column['name'] . "=" ."'" . $value . "'";
          break;
        case 'date':
        case 'datenull':
          $value = $this->request[$column['name']];
          if (isset($value) && $value != '0-00-0') {
            $value = almdata::escape($this->request[$column['name']]);
            $values .= $column['name'] . "= '" . $value . "'";
          } else {
            $values .= $column['name'] . "=NULL";
          }
          break;
        default:
          if (isset($this->request[$column['name']])) {
            $value = ($this->escaped) ? $this->request[$column['name']] : almdata::escape($this->request[$column['name']]);
            $values .= $column['name'] . "=" ."'" . $value . "'";
          } else {
            $values .= $column['name'] . "=NULL";
          }
          break;
      }
      $n++;
      if ($maxcols && (($n+$skipped_cols) >= $maxcols)) break;
    }