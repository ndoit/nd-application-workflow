feature 'Workflow with only FYI' do
  it 'should not have JS errors', js: true do
    visit '/'
    expect(page).not_to have_errors
  end

  it 'returns negative result on search that does not match', js: true do
    visit '/parent_records/new/false'
    find('a.button#b_add_nd_workflow', text: 'Add Notification').click
    find('input#f_nd_workflow_input_net_id').set('kbarrett8')
    find('a.button#b_nd_workflow_find_employee', text: 'Find').click
    message = find('#nd_workflow_employee_not_found')
    expect(message.text).to eq 'An employee could not be found with the provided information. Please check your entries and try again.'
  end

  it 'returns a single result for an exact match', js: true do
    visit '/parent_records/new/false'
    find('a.button#b_add_nd_workflow', text: 'Add Notification').click
    find('input#f_nd_workflow_input_net_id').set('kbarret8')
    find('a.button#b_nd_workflow_find_employee', text: 'Find').click
    list = find('#nd_workflow_entry_results_list')
    result = list.find('div.ndwf_list#ndwf_add_KBARRET8')
    expect(result.text).to eq 'Kingdon Barrett KBARRET8Appl Dvlpmnt Professional29015, Customer IT Solutions'
  end
end
