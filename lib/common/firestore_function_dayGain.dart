/*
/sales/kaushal312@gmail.com/-L_31RquPasJKz-0bWiS/-LaM8giaVm9_v8ocTaM4

/sales/kaushal312@gmail.com/{storeId}/{newDocId}
{productId
Q
subQ
}

if(any updates to /sales/kaushal312@gmail.com/{storeId}/{newDocId})
{
	store = /stores/kaushal312@gmail.com/user_stores/-L_31RquPasJKz-0bWiS
	if(current_date > store.lastRecordedDate)
		daySale = /sales/kaushal312@gmail.com/{storeId}/{newDocId}/value;
	else
		if(current_date == store.lastRecordedDate)
		daySale = daySale + /sales/kaushal312@gmail.com/{storeId}/{newDocId}/value;	

   set(daySale, currentDate);
}
*/