*** Variables ***
${url}    https://www.sreality.cz
${search}    /hledani/prodej/byty/praha?velikost=1%2Bkk&bez-aukce=1
${browser}    chrome
${paging_count_css}    css:.paging .info .numero:nth-child(2)
${paging}    20
${paging_current_css}    css:.paging .paging-full .active
${property_name_css}    css:.dir-property-list .property h2 span
${property_link_css}    css:.dir-property-list .property h2 .title
${property_link_attribute}    ng-href
${result_csv}    results/list.csv
${property_assert_css}    css:.property-title
@{property_variables_names}    Nazev    Adresa    Cena    URL 
@{property_variables_css}    css:.property-title .name    css:.property-title .location-text    css:.property-title .norm-price