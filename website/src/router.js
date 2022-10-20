import Home from './pages/Home.vue';
import Event from './pages/Event.vue';
import { createRouter, createWebHistory } from 'vue-router';

const routes = [
	{ path: '/', component: Home },
	{ path: '/events/:id', component: Event },
	{
		path: '/install',
		beforeEnter(to, from, next) {
			window.location.href = "/pomagacze.apk";
		}
	}
];

const router = createRouter({
	history: createWebHistory(),
	routes,
});

export default router;