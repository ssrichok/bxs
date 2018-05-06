<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="/WEB-INF/telogic-custom.tld" prefix="tlg"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<script type="text/javascript" charset="utf-8">
var indexUrl = '<c:url value="/web/ussdpush/vlr_file"/>' ;
var loadEditUrl= '<c:url value="/web/ussdpush/vlr_file/loadEditData"/>' ;
var uploadUrl = '<c:url value="/web/ussdpush/vlr_file/multiPartFileSingle"/>' ;

var status_messages ='<c:out value="${empty status_messages ? '[]' : status_messages   }"  escapeXml="false" />';
var success_status ='<c:out value="${empty success_status ? '' : success_status   }"  escapeXml="false" />';
var user_level = '<c:out value="${sessionScope.user_level}"  escapeXml="false" />';
var setReadOnly="";
$(function() {
	setReadOnly=function(isRead){
		 if(isRead){
			 $("#uploadPath").children().each(function() {
				  $(this).prop('disabled', true);
			 });
			 $("#editFile").prop('disabled', true);
			 $("#deleteFile").prop('disabled', true);
		 }
	}
	
	function initUserLevel(){
		if(user_level == USER_ROLE_VIEWER){
			 $('.panel-right-comment').hide();
			 $('.upload-box').hide();
			 $('#adminSubmit').hide();
		}
	}
	initUserLevel();
	initMessageStatus(status_messages,success_status);
	
	$('#editFile' ).click(function(){
		var isValid= $("#vlrlist").valid();
		if(isValid){
			  var data = $('#vlrlist').serializeArray();
			  $.ajax({
				    url: loadEditUrl,
	                dataType: 'json',  // what to expect back from the PHP script, if anything
	                data: data,
	                type: 'post',
	                success: function( response ){
	                try {
	    				    if (response.error_message != "") 
	    				    {
	    				    	var data=response.error_message;
	    							modal.alert(  $(this),data);
	    					} else {
	    						$('#EditTextArea' ).val( response.msg );
	    						editData();
	    					}
	    			}
	    			catch(err) {
		    				if(response==undefined){
		    					window.location = indexUrl;
		    				}
		    			     modal.alert( $(this), response);
		    			     $(this).dialog('close');
		    			}
	                	       
	                },
	                /*
	                complete: function(response) {
	                	alert(response+"compleate");
	                	input.replaceWith(input.val('').clone(true));        
	                },*/
	    		    error: function(response)
	    		    {
	    		    	alert('Error: ' + response.responseText);
	    		    	$(this).dialog('close');
	    		    	//input.replaceWith(input.val('').clone(true));         
	    		    }
	     });
		}
		
	});
	
	
	
	function editData() {
		// Define the Dialog and its properties.
		$('#'+'dialog-message-edit').dialog({
			resizable : false,
			modal : true,
			title : "Edit",
			height : 430,
			width : 630,
			buttons : {
				"Save" : function() {
					var dataInput = $('#vlrlist').serializeArray();
					dataInput.push({name: 'action', value: 'editFile'});
					dataInput.push({name: 'msg', value: $("#EditTextArea").val()});
					$.ajax({
							    url: indexUrl,
				                dataType: 'json',  // what to expect back from the PHP script, if anything
				                data: dataInput,
				                type: 'post',
				                success: function( response ){
				                try {
				                	if(response.popup != undefined){
				                	    var str="";
			    				    	if( response.dataPromotions[0] != "" && response.dataPromotions[0]!= null ){
		    				    			str+= "<b>'" + dataInput[0].value;
		    				    			str+= "' is still in used by Promotion.</b><br/>";
		    				    			str+= " Promotion name : "+response.dataPromotions[0].data + " <br/>";
		    				    			for (var i=1;i<response.dataPromotions.length;++i){
		    				    				str+= " Promotion name : "+ response.dataPromotions[i].data  + " <br/>";
		    				    			}
			    				    	} 
			    				    		
		    				    		if( response.dataPromotionProfiles[0] != "" && response.dataPromotionProfiles[0] != null ){
		    				    			str+= "<b>'"+dataInput[0].value;
	    				    				str+= "' is still in used by Promotion Profile</b><br/>";
	    				    				str+= " Promotion Profile name : " + response.dataPromotionProfiles[0].data +  " <br/>";
	    				    				for (var i=1;i<response.dataPromotionProfiles.length;++i){
	    				    					str+= " Promotion Profile name : " + response.dataPromotionProfiles[i].data  + " <br/>";
	    				    				}
	    				    	   	 	} 
			    				    	confirmEdit(str);
			    				    	 
			    				    }
			    				    else if (response.error_message != "") {
			    					 	
			    				    	var data=response.error_message;
			    							modal.alert( $(this),data);
			    							$('#btnResetUpload').trigger('click');
			    					} else {
			    		
			    						 window.location = indexUrl;
			    	
			    					}
				    			}
				    			catch(err) {
					    				if(response==undefined){
					    					window.location = indexUrl;
					    				}
					    			     modal.alert( $(this), response);
					    			     $(this).dialog('close');
					    			}
				                	       
				                },
				                /*
				                complete: function(response) {
				                	alert(response+"compleate");
				                	input.replaceWith(input.val('').clone(true));        
				                },*/
				    		    error: function(response)
				    		    {
				    		    	alert('Error: ' + response.responseText);
				    		    	$(this).dialog('close');
				    		    	//input.replaceWith(input.val('').clone(true));         
				    		    }
				     });
					
				},
				"Cancel" : function() {
					$(this).dialog('close');
				}
			}
		});
	}
	function confirmEdit(msg) {
		var st= "" +msg;
		$('#dialog-confirm-upload').html(st);
		//dialog-confirm-upload
		$('#dialog-confirm-upload').dialog({
			modal : true,
			title : "Do you want to edit this file ? ",
			minWidth : 400,
			buttons : {
				"Ok" : function() {
					$(this).dialog('close');
					 //ajaxSubmitConfirm();
					var dataInput = $('#vlrlist').serializeArray();
					dataInput.push({name: 'action', value: 'editFile'});
					dataInput.push({name: 'msg', value: $("#EditTextArea").val()});
					dataInput.push({name: 'confirm', value:true });
					  $.ajax({
						    url: indexUrl,
			                dataType: 'json', 
			                data: dataInput,
			                type: 'post',
			                success: function( response ){
			                try {
			    				    if (response.error_message != "") {
			    				    	var data=response.error_message;
			    							modal.alert( $(this),data );
			    					} else {
			    						window.location = indexUrl;
			    					}
			    			}
			    			catch(err) {
				    				if(response==undefined){
				    					window.location = indexUrl;
				    				}
				    			     modal.alert( $(this), response);
				    			     $(this).dialog('close');
				    			}       
			                },
			                /*
			                complete: function(response) {
			                	alert(response+"compleate");
			                	input.replaceWith(input.val('').clone(true));        
			                },*/
			    		    error: function(response)
			    		    {
			    		    	alert('Error: ' + response.responseText);
			    		    	 
			    		    	//input.replaceWith(input.val('').clone(true));         
			    		    }
			     });
				},
				"Cancel" : function() {
					$(this).dialog('close');
					$('#'+'dialog-message-edit').dialog('close');
				}
			}
		});
	}
	function confirmUpload(msg) {
		var st= "" +msg;
		$('#dialog-confirm-upload').html(st);
		// Define the Dialog and its properties.
		//dialog-confirm-upload
		$('#dialog-confirm-upload').dialog({
			modal : true,
			title : "Do you want to overwrite the existing file ? ",
			minWidth : 400,
			buttons : {
				"Ok" : function() {
					 ajaxSubmitConfirm();
				},
				"Cancel" : function() {
					$(this).dialog('close');
				}
			}
		});
	}
	function ajaxSubmitConfirm(){
		  var file_data = $('#file').prop('files')[0];   
		    if(file_data==undefined){
		    	return false;
		    }
		    var form_data = new FormData(); 
		    form_data.append('confirm', true);
		    form_data.append('file', file_data);
		    $.ajax({
		    	 		url:uploadUrl,
		                dataType: 'json',  // what to expect back from the PHP script, if anything
		                cache: false,
		                contentType: false,
		                processData: false,
		                data: form_data,
		                type: 'post',
		                success: function( response ){
		                try {
		    					if (response.error_message != "") {
		    				    	var data=response.error_message;
		    							modal.alert(  $(this),data);
		    					} else {
		    						 window.location = indexUrl;
		    					}
		    			}
		    			catch(err) {
			    				if(response==undefined){
			    					window.location = indexUrl;
			    				}
			    			     modal.alert( $(this), response);
			    			}
		                	       
		                },
		                /*
		                complete: function(response) {
		                	alert(response+"compleate");
		                	input.replaceWith(input.val('').clone(true));        
		                },*/
		    		    error: function(response)
		    		    {
		    		    	alert('Error: ' + response.responseText);
		    		    	//input.replaceWith(input.val('').clone(true));         
		    		    }
		     });
		    
		 
	}

	$("#vlrlist").validate({
	    
	});
	
	$('#upload').on('click', function() {
	    var file_data = $('#file').prop('files')[0];   
	    if(file_data==undefined){
	    	return false;
	    }
	    var form_data = new FormData();                  
	    form_data.append('file', file_data);
	    $.ajax({
    	 		url:uploadUrl,
                dataType: 'json',  
                cache: false,
                contentType: false,
                processData: false,
                data: form_data,
                type: 'post',
                success: function( response ){
	             try {
	                	if(response.popup != undefined){
		                	var str="<b>"+file_data.name+"  already exists.</b><br/>";
					    	if( response.dataPromotions[0] != "" && response.dataPromotions[0] != null ){
				    			str+= "<b>used by Promotion</b><br/>";
				    			str+= " Promotion name : "+ response.dataPromotions[0].data + " <br/>";
				    			for (var i=1;i<response.dataPromotions.length;++i){
				    				str+= " Promotion name : "+ response.dataPromotions[i].data  + " <br/>";
				    			}
					    	} 
		
			    			if( response.dataPromotionProfiles[0] != "" && response.dataPromotionProfiles[0] != null ){
			    				str+= "<b>used by Promotion Profile</b><br/>";
			    				str+= " Promotion Profile name : " + response.dataPromotionProfiles[0].data +  " <br/>";
			    				for (var i=1;i<response.dataPromotionProfiles.length;++i){
			    					str+= " Promotion Profile name : " + response.dataPromotionProfiles[i].data  + " <br/>";
			    				}
			    	   	 	} 
    				    	confirmUpload(str); 
    				    }
    				    else if (response.error_message != "") {
    				    	var data=response.error_message;
    							modal.alert(  $(this),data);
    							$('#btnResetUpload').trigger('click');
    					} else {
    						 window.location = indexUrl;
    					}
	    			}
	    			catch(err){
	    				if(response==undefined){
	    					window.location = indexUrl;
	    				}
	    			    modal.alert( $(this), response);
		    		}  
                },
    		    error: function(response){
    		    	alert('Error: ' + response.responseText);
    		    	//input.replaceWith(input.val('').clone(true));         
    		    }
	     });
	    return false;
	});
 
 
});
</script>
<title>Calculate Mobile  Price</title>
</head>
<body topmargin="0" leftmargin="0">
	<div class="divbody">
		
		<div id="statusMessages" class="alert " style="width: 70%; margin-top: 5px; display: none;">
			<a class="close">×</a> 
			<span id='msgDone'> <strong>Done! </strong></span> 
			<span id='msgFail'> <strong>Failure! </strong></span> 
			<span style="margin-left: 5px" id="msgStatus"></span>
		</div>
		<div class="section body-box-line" style="width:98%;">
			<span class="page-title">VLR File</span><br /><br />
			<div style="width: 100%">
				<div class="panel-box panel-file">
					<form:form modelAttribute="vlrlist" method="post" style="margin-left:10px;" autocomplete="off">
						<table id="filelist" style="margin-top: 20px">
							<tbody>
								<tr>
									
									<td valign="top">
										<ul style="list-style: none;">
											<li><form:button type="submit" id="downloadFile" name="action" value="downloadFile" class="btn btn-primary" onclick="" style="width: 100px; margin-bottom: 10px">Download</form:button></li>
											<span id="adminSubmit">
												<li><input type="button" value="Edit" id="editFile" name="action" class="btn btn-primary" style="width: 100px; margin-bottom: 10px" /></li>
												<li><input type="button" value="Delete" id="deleteFile" name="action" class="btn btn-primary" style="width: 100px; margin-bottom: 10px" /></li>
											</span>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</form:form>
					<form method="post" action="" autocomplete="off">
						<div class="upload-box" id="uploadPath" style="width: 570px;">
							<strong>VLR File Upload</strong>(VLR format specifically is telephone number only)<br />
							<input autocomplete="off" id="file" type="file" name="file" accept="text/plain" />
							<br /> <br />
							<button id="upload" class="btn btn-primary" style="width: 84px; margin-left: 10px;" autocomplete="off">Add</button>
							<input id="btnResetUpload" name="btnReset" class="btn btn-default" style="width: 84px; margin-left: 10px" type="reset" value="Reset" autocomplete="off"/>
						</div>
					</form>
				</div>
				<div class="panel-right-comment" style="min-width:190px !important;">
					<h5>Example Format</h5>
					<br /> <b>promotion1.log</b><br /> 22/06/2013|10:21:55|10:40:57|0810660431|P1 <br /> 
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<!-- Popup dialog -->
	<div id="myModal" style="display: none"></div>
	<!-- loading -->
	<div class="modal-loading">
		<!-- Place at bottom of page -->
	</div>
	<!-- confirm upload -->
	<div id="dialog-confirm-upload" style="display: none">This file already exists.</div>

	<!-- confirm delete -->
	<div id="dialog-confirm-delete" style="display: none">Do you want to delete?</div>
	<div id="dialog-message-edit" style="display: none" title="Edit">
		<div>
			<textarea id="EditTextArea"
				style="height: 300px; width: 600px; padding: 5px; font-family: Sans-serif; font-size: 1.2em;"></textarea>
		</div>
	</div>
</body>
</html>