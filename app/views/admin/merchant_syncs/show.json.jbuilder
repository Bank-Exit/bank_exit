if params[:new] == 'true'
  json.cache! [:new, @merchant_sync], expires_in: 1.day do
    json.extract! @merchant_sync, :payload_added_merchants
  end
elsif params[:updated] == 'true'
  json.cache! [:updated, @merchant_sync], expires_in: 1.day do
    json.extract! @merchant_sync, :payload_updated_merchants
  end
elsif params[:deleted] == 'true'
  json.cache! [:new, @merchant_sync], expires_in: 1.day do
    json.extract! @merchant_sync, :payload_soft_deleted_merchants
  end
else
  json.cache! [@merchant_sync], expires_in: 1.day do
    json.extract! @merchant_sync,
                  :payload_added_merchants,
                  :payload_updated_merchants,
                  :payload_soft_deleted_merchants
  end
end
