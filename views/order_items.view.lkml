view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: number_of_items_sold {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales_price{
    type:  sum
    sql: ${sale_price};;
    value_format_name: usd
  }

  measure: average_sales_price{
    type:  average
    sql: ${sale_price};;
    value_format_name: usd
  }

  measure:  cumulative_total_sales{
    type: running_total
    sql: ${total_sales_price};;
    value_format_name: usd
  }

  measure: total_gross_revenue{
    type:  sum
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    filters: [status: "Complete"]
    sql: ${sale_price};;
    value_format_name: usd
  }

  measure: number_of_items_returned {
    type: count
    filters: [status: "Returned"]
  }

  measure: item_return_rate {
    type: number
    description: "Number of Items Returned / total number of items sold"
    sql: 1.00 * ${number_of_items_returned} / ${number_of_items_sold};;
    value_format_name: percent_2
  }

  measure: number_of_users_returning_items {
    type: count_distinct
    filters: [status: "Returned"]
    sql: ${user_id} ;;
  }

  measure: count_of_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: percentage_of_users_with_returns {
    type: number
    sql:  1.00 * ${number_of_users_returning_items} / nullifzero(${count_of_users});;
    value_format_name: percent_2
  }

  measure: total_gross_margin {
    type: number
    description: "Total difference between the total revenue from completed sales and
    the cost of the goods that were sold"
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd
  }

  measure: average_gross_margin {
    type: number
    description: "Average difference between the total revenue from completed sales and
                  the cost of the goods that were sold"
    sql: ${total_gross_margin} / ${number_of_items_sold} ;;
    value_format_name: usd
  }

  measure: gross_margin_percent {
    type: number
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: 1.00 * ${total_gross_margin} / nullifzero(${total_gross_revenue}) ;;
    value_format_name: percent_2
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
