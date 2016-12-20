
// ****************  nd_workflow functions ************************************
function enable_nd_workflows() {
  $('#b_add_nd_workflow').click( function() {
      show_search_for_nd_workflow();  });
  $('#b_nd_workflow_add_cancel').click( function() {
      $('#nd_workflow_entry').foundation('reveal','close');
      $('#nd_workflow_find_employee_processing').removeClass("ajax-processing");
  });
  $('#b_nd_workflow_find_employee').click( function() {
      find_nd_workflow_employees();
  });
  $('.nd_workflow_approval_cb').on('change',function() {
      set_workflow_type_on_approval_checkbox_change(this);
  });
  $('.nd_workflow_find_employees_on_return').keypress( function( event) {
    find_nd_workflow_employee_on_return( event, this);
  });

}

function show_search_for_nd_workflow() {
  $('#f_nd_workflow_input_last').val('');
  $('#f_nd_workflow_input_first').val('');
  $('#f_nd_workflow_input_net_id').val('');
  $('#nd_workflow_employee_not_found').hide();
  $('#nd_workflow_entry_results_table >tbody >tr').remove();
  $('#nd_workflow_entry_results').hide();
  $('#nd_workflow_entry').foundation('reveal','open');
}

function add_nd_workflow_user(row_clicked) {
    var net_id = row_clicked.id.substring(9);
    var first_name = $(row_clicked).find('.ndwf_first_name').text();
    var last_name = $(row_clicked).find('.ndwf_last_name').text();
    $('#b_nd_workflow_insert').click();
    var nd_workflow_data_rows = $('#nd_workflow_list >div.nested-fields');
    i = nd_workflow_data_rows.length - 1;
    var display_name_spans = $('span.nd_workflow_name');
    display_name_spans[i].innerText = first_name + " " + last_name;
    var display_netid_spans = $('span.nd_workflow_netid');
    display_netid_spans[i].innerText = net_id;
    var input_first_names = $('input.nd_workflow_assigned_to_first_name');
    input_first_names[i].value = first_name;
    var input_last_names = $('input.nd_workflow_assigned_to_last_name');
    input_last_names[i].value = last_name;
    var input_net_ids = $('input.nd_workflow_assigned_to_netid');
    input_net_ids[i].value = net_id;
    var current_user_netid = $('#nd_workflow_current_user_id');
    if (current_user_netid.length > 0 ) {
      var input_created_by_netid = $('input.nd_workflow_created_by_netid');
      input_created_by_netid[i].value = current_user_netid[0].value;
    }
    var input_workflow_types = $('input.nd_workflow_type');
    input_workflow_types[i].value = 'fyi';
    var input_workflow_manual = $('input.nd_workflow_auto_or_manual');
    input_workflow_manual[i].value = 'manual';
    var input_nd_workflow_include_details_cb = $('input.nd_workflow_email_include_detail_cb');
    input_nd_workflow_include_details_cb[i].checked = true;
    $('.nd_workflow_approval_cb').on('change',function() {
         set_workflow_type_on_approval_checkbox_change(this);
       });

    $('#nd_workflow_entry').foundation('reveal','close');
}

function find_nd_workflow_employee_on_return( e, field) {

  var key=e.keyCode || e.which;
  if (key == 13) {
    find_nd_workflow_employees();
  }
}

/*******************************************/
function find_nd_workflow_employees() {
  $('#nd_workflow_employee_not_found').hide();
  $('#nd_workflow_employee_invalid_entries').hide();
  $('#nd_workflow_entry_results_list >div').remove();
  var lname = encodeURIComponent($('#f_nd_workflow_input_last').val());
  var fname = encodeURIComponent($('#f_nd_workflow_input_first').val());
  var netid = encodeURIComponent($('#f_nd_workflow_input_net_id').val());

  var lookup_url = "/employee-lookup/employee/active";
  if (lname != "") {
    lookup_url = lookup_url + '/l/' + lname;
    if (fname != "")
      lookup_url = lookup_url + '/' + fname;
  }
  else {
    if (netid != "")  lookup_url = lookup_url + '/' + netid;
    else  {
        $('#nd_workflow_employee_invalid_entries').show();
        return;
    }
  }
//  lookup_url = lookup_url + ".json";
  $('#nd_workflow_find_employee_processing').addClass("ajax-processing");
  $.ajax({ url: lookup_url,
    contentType: "json",
    dataType: "json",
    cache: false,
    error: function(XMLHttpRequest, textStatus, errorThrown) {
                    $('#nd_workflow_find_employee_processing').removeClass("ajax-processing");
                    do_alert("An error has occurred while attempting to retrieve employee data.  Please confirm that all necessary web services are running. (Find nd_workflow employee: " + errorThrown + ")");      },
    success: function (data, status, xhr) {
      if (data.length == 0) {
        $('#nd_workflow_entry_results_list >div').remove();
        $('#nd_workflow_employee_not_found').show();
      }
      else {
        if (data[0].Employee == "None") {
            $('#nd_workflow_entry_results_list >div').remove();
            $('#nd_workflow_employee_not_found').show();
        }
        else {
          var employees_count = 0;
          $('#nd_workflow_entry_results_list >div').remove();
          for (i = 0; i < data.length; i++) {
            if (data[i].Employee == "Error") {
              alert(data[i].employee_title);
            }
            if (data[i].employee_status == "A") {
              var row_string = "<div class='row ndwf_list' id='ndwf_add_" + data[i].net_id +"'>";
              row_string += "<div class='columns small-3'>";
              row_string += "<span class='ndwf_first_name'>" + data[i].first_name + "</span>&nbsp;";
              row_string += "<span class='ndwf_last_name'>" + data[i].last_name + "</span><br/>";
              row_string += "<span class='ndwf_netid'>" + data[i].net_id + "</span>";
              row_string += "</div>";
              row_string += "<div class='columns small-5'>";
              row_string += data[i].primary_title;
              row_string += "</div>";
              row_string += "<div class='columns small-4'>";
              row_string += data[i].home_orgn + ", " + data[i].home_orgn_desc;
              row_string += "</div>";

              row_string += "</div>";

              $('#nd_workflow_entry_results_list').append(row_string);
              employees_count += 1;
            }
          }
          if (employees_count == 0)
            $('#nd_workflow_employee_not_found').show();
          else
            $('#nd_workflow_entry_results').show();
        }
      }

      $('.ndwf_list').on('click', function() {
        add_nd_workflow_user(this);
      });

      $('#nd_workflow_find_employee_processing').removeClass("ajax-processing");
    }
  });

}

function set_workflow_type_on_approval_checkbox_change (approval_checkbox) {
  var workflow_type_field = approval_checkbox.nextElementSibling;
  if (approval_checkbox.checked) {
    workflow_type_field.value = 'approval';
  }
  else {
    workflow_type_field.value = 'fyi';
  }

}
