<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">  
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>almidon @ {$smarty.const.DOMAIN}</title>
{literal}
<link rel="stylesheet" href="/cms/css/admin_login.css" />
<script language="javascript" type="text/javascript">
	function setFocus() {
		document.loginForm.almuser.select();
		document.loginForm.almuser.focus();
	}
</script>
{/literal}
</head>
<body onload="setFocus();">
<div align="center">
	<div class="login">
		<div>
        		<p><img src="/img/almidon-atma.png" width="262" height="78" alt="Almidon Logo" title="Almidon" /></p>
    		</div>
        	<form action="" method="post" id="loginForm" name="loginForm">
			<div class="form-block">
	        		<b>{$smarty.const.ALM_USERNAME}</b>
		    		<div><input id="almuser" name="almuser" type="text" class="inputbox" size="15" /></div>
	        		<b>{$smarty.const.ALM_PASSWORD}</b>
	    	  		<div><input id="password" name="password" type="password" class="inputbox" size="15" /></div>
		                <b>CAPTCHA</b> <img src="captcha.png" width="55" height="20" alt="CAPTCHA"/>
				<div><input name="txtcaptcha" class="inputbox" type="text" size="8"/></div>
	        		<div align="center"><input type="submit" name="submit" class="button" value="{$smarty.const.LOGIN}" /></div>
        		</div>
		</form>
                {if $bError}<div class="error">{$smarty.const.ALM_PASS_ERROR}</div>{/if}
                {if $sError}<div class="error">{$smarty.const.ALM_NO_COOKIE}</div>{/if}
	</div>
</div>
</body>
</html>
