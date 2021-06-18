view: products {
  sql_table_name: "PUBLIC"."PRODUCTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}."BRAND" ;;
    drill_fields: [products.category,products.name,order_items.total_gross_revenue]
    link: {

      url: "{{link}}&sorts=order_items.total_gross_revenue+desc&query_timezone=America%2FLos_Angeles&vis=%7B%22show_view_names
            %22%3Afalse%2C%22show_row_numbers%22%3Atrue%2C%22transpose%22%3Afalse%2C%22truncate_text%22%3Atrue%2C%22hide_totals
            %22%3Afalse%2C%22hide_row_totals%22%3Afalse%2C%22size_to_fit%22%3Atrue%2C%22table_theme%22%3A%22white%22%2C
            %22limit_displayed_rows%22%3Atrue%2C%22enable_conditional_formatting%22%3Afalse%2C%22header_text_alignment
            %22%3A%22left%22%2C%22header_font_size%22%3A%2212%22%2C%22rows_font_size%22%3A%2212%22%2C
            %22conditional_formatting_include_totals%22%3Afalse%2C%22conditional_formatting_include_nulls%22%3Afalse%2C
            %22show_sql_query_menu_options%22%3Afalse%2C%22show_totals%22%3Atrue%2C%22show_row_totals%22%3Atrue%2C
            %22series_labels%22%3A%7B%22No+-+order_items.total_gross_revenue%22%3A%22Long+Term+Customers%22%2C
            %22Yes+-+order_items.total_gross_revenue%22%3A%22New+Customers%22%7D%2C%22limit_displayed_rows_values%22%3A%7B
            %22show_hide%22%3A%22show%22%2C%22first_last%22%3A%22first%22%2C%22num_rows%22%3A%2210%22%7D%2C%22x_axis_gridlines
            %22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C
            %22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label
            %22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed
            %22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C
            %22stacking%22%3A%22%22%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C
            %22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined
            %22%3Atrue%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C
            %22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22map_plot_mode%22%3A%22points%22%2C
            %22heatmap_gridlines%22%3Atrue%2C%22heatmap_gridlines_empty%22%3Afalse%2C%22heatmap_opacity%22%3A1%2C
            %22show_region_field%22%3Atrue%2C%22draw_map_labels_above_data%22%3Atrue%2C%22map_tile_provider%22%3A
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
            %22%3Afalse%7D&filter_config=%7B%7D&dynamic_fields=%5B%5D&origin=share-expanded"  }
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}."RETAIL_PRICE" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
