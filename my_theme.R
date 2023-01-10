library(fresh)

my_theme <- create_theme(
    adminlte_color(
        light_blue = "#434C5E"
    ),
    adminlte_sidebar(
        width = "400px",
        dark_bg = "black",
        dark_hover_bg = "black",
        dark_color = "#2E3440",
        light_bg = "black"
            
    ),
    adminlte_global(
        content_bg = "#FFF",
        box_bg = "#D8DEE9", 
        info_box_bg = "#D8DEE9"
    )

)

