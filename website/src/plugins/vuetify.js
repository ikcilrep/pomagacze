// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Vuetify
import { createVuetify } from 'vuetify'

export default createVuetify(
	{
		theme: {
			themes: {
				'pomagacze': {
					dark: false,
					colors: {
						'primary': '#009688',
						'secondary': '#80cbc4',
						'error': '#d32f2f',
						'surface': '#ebf6f5',
						'background': '#fafafa',
					}
				}
			},
			defaultTheme: 'pomagacze'
		}
	}
)
