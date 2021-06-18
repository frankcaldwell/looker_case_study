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

  dimension: created_at {
    type: date
    hidden: yes
    sql: ${TABLE}."created_at" ;;
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
    filters: [status: "-Returned", status: "-Cancelled"]
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
    drill_fields: [products.brand,products.category,order_items.total_gross_margin]
    link: {

      url: "{{link}}&sorts=order_items.total_gross_margin+desc,products.brand,products.category&query_timezone=America
            %2FLos_Angeles&vis=%7B%22show_view_names%22%3Afalse%2C%22show_row_numbers%22%3Atrue%2C%22transpose%22%3Afalse%2C
            %22truncate_text%22%3Atrue%2C%22hide_totals%22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22size_to_fit%22%3Atrue
            %2C%22table_theme%22%3A%22white%22%2C%22limit_displayed_rows%22%3Atrue%2C%22enable_conditional_formatting
            %22%3Afalse%2C%22header_text_alignment%22%3A%22left%22%2C%22header_font_size%22%3A%2212%22%2C%22rows_font_size
            %22%3A%2212%22%2C%22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls
            %22%3Afalse%2C%22show_sql_query_menu_options%22%3Afalse%2C%22show_totals%22%3Atrue%2C%22show_row_totals
            %22%3Atrue%2C%22series_labels%22%3A%7B%22No+-+order_items.total_gross_revenue%22%3A%22Long+Term+Customers%22%2C
            %22Yes+-+order_items.total_gross_revenue%22%3A%22New+Customers%22%7D%2C%22limit_displayed_rows_values%22%3A%7B
            %22show_hide%22%3A%22show%22%2C%22first_last%22%3A%22first%22%2C%22num_rows%22%3A%2210%22%7D%2C
            %22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_y_axis_labels%22%3Atrue%2C
            %22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom
            %22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear
            %22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C
            %22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A
            %22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C
            %22y_axis_combined%22%3Atrue%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels
            %22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22map_plot_mode%22%3A
            %22points%22%2C%22heatmap_gridlines%22%3Atrue%2C%22heatmap_gridlines_empty%22%3Afalse%2C%22heatmap_opacity
            %22%3A1%2C%22show_region_field%22%3Atrue%2C%22draw_map_labels_above_data%22%3Atrue%2C%22map_tile_provider%22%3A
            %22light%22%2C%22map_position%22%3A%22custom%22%2C%22map_latitude%22%3A38.59674884151356%2C%22map_longitude
            %22%3A-101.70387268066408%2C%22map_zoom%22%3A4%2C%22map_scale_indicator%22%3A%22imperial%22%2C%22map_pannable
            %22%3Atrue%2C%22map_zoomable%22%3Atrue%2C%22map_marker_type%22%3A%22circle%22%2C%22map_marker_icon_name%22%3A
            %22default%22%2C%22map_marker_radius_mode%22%3A%22proportional_value%22%2C%22map_marker_units%22%3A%22meters%22%2C
            %22map_marker_proportional_scale_type%22%3A%22linear%22%2C%22map_marker_color_mode%22%3A%22fixed%22%2C
            %22show_legend%22%3Atrue%2C%22quantize_map_value_colors%22%3Afalse%2C%22reverse_map_value_colors%22%3Afalse%2C
            %22map%22%3A%22usa%22%2C%22map_projection%22%3A%22%22%2C%22font_size%22%3A12%2C%22series_types%22%3A%7B%7D%2C
            %22trend_lines%22%3A%5B%5D%2C%22show_null_points%22%3Atrue%2C%22interpolation%22%3A%22linear%22%2C%22type%22%3A
            %22looker_grid%22%2C%22defaults_version%22%3A1%2C%22value_labels%22%3A%22legend%22%2C%22label_type%22%3A%22labPer
            %22%2C%22hidden_fields%22%3A%5B%5D%2C%22hidden_points_if_no%22%3A%5B%5D%2C%22quantize_colors
            %22%3Afalse%7D&filter_config=%7B%7D&dynamic_fields=%5B%5D&origin=share-expanded"}
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

  measure: average_spend_per_customer {
    type: number
    sql: ${total_gross_revenue} / ${count_of_users} ;;
    value_format_name: usd
    drill_fields: [order_items.average_spend_per_customer,users.age_tier,users.gender]
    link: {

      url: "{{link}}&pivots=users.gender&f[order_items.gross_margin_percent]=%3E0&sorts=users.age_tier,
            users.gender&limit=10&query_timezone=America%2FLos_Angeles
            &vis=%7B%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C
            %22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks
            %22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom
            %22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C
            %22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C
            %22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C
            %22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position
            %22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C
            %22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C
            %22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels
            %22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C
            %22map_plot_mode%22%3A%22points%22%2C%22heatmap_gridlines%22%3Atrue%2C
            %22heatmap_gridlines_empty%22%3Afalse%2C%22heatmap_opacity%22%3A1%2C
            %22show_region_field%22%3Atrue%2C%22draw_map_labels_above_data%22%3Atrue%2C
            %22map_tile_provider%22%3A%22light%22%2C%22map_position%22%3A%22custom%22%2C
            %22map_latitude%22%3A38.59674884151356%2C%22map_longitude%22%3A-101.70387268066408%2C
            %22map_zoom%22%3A4%2C%22map_scale_indicator%22%3A%22imperial%22%2C%22map_pannable%22%3Atrue%2C
            %22map_zoomable%22%3Atrue%2C%22map_marker_type%22%3A%22circle%22%2C
            %22map_marker_icon_name%22%3A%22default%22%2C%22map_marker_radius_mode
            %22%3A%22proportional_value%22%2C%22map_marker_units%22%3A%22meters%22%2C
            %22map_marker_proportional_scale_type%22%3A%22linear%22%2C%22map_marker_color_mode%22%3A
            %22fixed%22%2C%22show_legend%22%3Atrue%2C%22quantize_map_value_colors%22%3Afalse%2C
            %22reverse_map_value_colors%22%3Afalse%2C%22map%22%3A%22usa%22%2C%22map_projection%22%3A
            %22%22%2C%22font_size%22%3A12%2C%22series_types%22%3A%7B%7D%2C%22series_labels%22%3A%7B
            %22No+-+order_items.total_gross_revenue%22%3A%22Long+Term+Customers%22%2C
            %22Yes+-+order_items.total_gross_revenue%22%3A%22New+Customers%22%7D%2C%22trend_lines
            %22%3A%5B%5D%2C%22show_null_points%22%3Atrue%2C%22interpolation%22%3A%22linear%22%2C
            %22type%22%3A%22looker_bar%22%2C%22defaults_version%22%3A1%2C%22value_labels%22%3A%
            22legend%22%2C%22label_type%22%3A%22labPer%22%2C%22hidden_fields%22%3A%5B%5D%2C%
            22hidden_points_if_no%22%3A%5B%5D%2C%22quantize_colors%22%3Afalse%2C%22show_row_numbers
            %22%3Atrue%2C%22transpose%22%3Afalse%2C%22truncate_text%22%3Atrue%2C%22hide_totals
            %22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22size_to_fit%22%3Atrue%2C%22table_theme
            %22%3A%22white%22%2C%22enable_conditional_formatting%22%3Afalse%2C%22header_text_alignment
            %22%3A%22left%22%2C%22header_font_size%22%3A12%2C%22rows_font_size%22%3A12%2C
            %22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls
            %22%3Afalse%7D&filter_config=%7B%22order_items.gross_margin_percent%22%3A%5B%7B%22type%22%3A
            %22%5Cu003e%22%2C%22values%22%3A%5B%7B%22constant%22%3A%220%22%7D%2C%7B%7D%5D%2C%22id%22%3A1%2C
            %22error%22%3Afalse%7D%5D%7D&dynamic_fields=%5B%5D&origin=share-expanded"  }


  }

  measure: percent_of_total_revenue {
    type: percent_of_total
    sql: ${total_gross_revenue} ;;
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
