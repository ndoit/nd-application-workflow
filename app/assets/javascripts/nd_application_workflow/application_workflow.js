
// ****************  nd_workflow functions ************************************
function enable_nd_workflows() {
  $('#b_add_nd_workflow').click( function() {
      show_search_for_nd_workflow();  });
  $('#b_nd_workflow_add_cancel').click( function() {
    $('#nd_workflow_entry').foundation('reveal','close');
    $('#nd_workflow_find_employee_processing').removeClass("ajax-processing");
  });
  $('#b_nd_workflow_find_employee').click( function() {
      find_nd_workflow_employees();  });
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

function add_nd_workflow_user(tr_clicked) {
    var net_id = tr_clicked.id.substring(7);
    var first_name = $(tr_clicked.children[0]).text();
    var last_name = $(tr_clicked.children[1]).text();
    $('#b_nd_workflow_insert').click();
    var nd_workflow_data_rows = $('#nd_workflows_table >tbody >tr.nested-fields');
    i = nd_workflow_data_rows.length - 1;
    var display_name_spans = $('span.nd_workflow_name');
    display_name_spans[i].innerText = first_name + " " + last_name;
    var display_netid_spans = $('span.nd_workflow_netid');
    display_netid_spans[i].innerText = net_id;
    var input_first_names = $('input.assigned_to_first_name');
    input_first_names[i].value = first_name;
    var input_last_names = $('input.assigned_to_last_name');
    input_last_names[i].value = last_name;
    var input_net_ids = $('input.assigned_to_netid');
    input_net_ids[i].value = net_id;
    var input_workflow_types = $('input.workflow_type');
    input_workflow_types[i].value = 'fyi';
    var input_workflow_manual = $('input.auto_or_manual');
    input_workflow_manual[i].value = 'manual';
    var input_nd_workflow_include_details_cb = $('input.nd_workflow_include_details_cb');
    input_nd_workflow_include_details_cb[i].checked = true;
    $('.nd_workflow_approval_cb').on('change',function() {
         set_workflow_type_on_approval_checkbox_change(this);
       });

    $('#nd_workflow_entry').foundation('reveal','close');
}
/*******************************************/
function find_nd_workflow_employees() {
  $('#nd_workflow_employee_not_found').hide();
  $('#nd_workflow_employee_invalid_entries').hide();
  $('#nd_workflow_entry_results_table >tbody >tr').remove();
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
        $('#nd_workflow_entry_results_table >tbody >tr').remove();
        $('#nd_workflow_employee_not_found').show();
      }
      else {
        if (data[0].Employee == "None") {
            $('#nd_workflow_entry_results_table >tbody >tr').remove();
            $('#nd_workflow_employee_not_found').show();
        }
        else {
          var employees_count = 0;
          $('#nd_workflow_entry_results_table >tbody >tr').remove();
          for (i = 0; i < data.length; i++) {
            if (data[i].employee_status == "A") {
              tr_string = "<td>" + data[i].first_name + "</td>";
              tr_string += "<td>"+ data[i].last_name + "</td>";
              tr_string += "<td>" + data[i].net_id + "</td>";
              tr_string += "<td>" + data[i].home_orgn + ", " + data[i].home_orgn_desc + "</td>";
              tr_string += "<td>" + data[i].primary_title + "</td>";
              $('#nd_workflow_entry_results_table').append("<tr class=\"ldc_list\" id=\"n_user_" + data[i].net_id + "\">" + tr_string + " </tr>");
              employees_count += 1;
            }
          }
          if (employees_count == 0)
            $('#nd_workflow_employee_not_found').show();
          else
            $('#nd_workflow_entry_results').show();
        }
      }

      $('#nd_workflow_entry_results_table >tbody >tr').on('click', function() {
        add_nd_workflow_user(this);
      });

      $('#nd_workflow_find_employee_processing').removeClass("ajax-processing");
    }
  });

}
