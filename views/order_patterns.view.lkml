view: order_patterns {
  derived_table: {
    sql: select user_id,
       order_id,
       created_at,
       row_number() over (partition by user_id order by created_at) as order_sequence

  from order_items;;
  }
  dimension: order_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: created_at {
    type: date_time
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }
  dimension: days_between_orders {
    type:  number
    sql: diff_days(${created_at},offset(${created_at},1)) ;;
  }
}
