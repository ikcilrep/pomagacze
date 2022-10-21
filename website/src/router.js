import Home from './pages/Home.vue';
import Event from './pages/Event.vue';
import NotFound from './pages/NotFound.vue';
import { createRouter, createWebHistory } from 'vue-router';

const routes = [
	{ path: '/', component: Home },
	{ path: '/event/:id', component: Event },
	{
		path: '/install',
		beforeEnter(to, from, next) {
			window.location.href = "/pomagacze.apk";
		}
	},
	{
		path: '/:catchAll(.*)',
		component: NotFound
	}
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

export default router;