#output "nlb1_url_list" { value = "${ concat(
  #local.nlb1stream1_url_list,
  #local.nlb1stream2_url_list,
#) }" }
#output "nlb2_url_list" { value = "${ concat(
  #local.nlb2stream1_url_list,
  #local.nlb2stream2_url_list,
#) }" }
#output "all_url_list"  { value = "${ concat(
  #local.nlb1stream1_url_list,
  #local.nlb1stream2_url_list,
  #local.nlb2stream1_url_list,
  #local.nlb2stream2_url_list,
#) }" }
