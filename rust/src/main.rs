extern crate sdl2;

use sdl2::pixels::Color;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::gfx::framerate::FPSManager;
use sdl2::rect::Rect;

const TITLE: &'static str = "Peco";
const WINDOW_WIDTH: u32 = 640;
const WINDOW_HEIGHT: u32 = 480;

const BALL_RADIUS: u32 = 5;
const BALL_VELOCITY_X: i32 = 5;
const BALL_VELOCITY_Y: i32 = 3;

#[derive(Debug)]
struct Ball {
    vel_x: i32,
    vel_y: i32,
    pub rect: Rect,
}

impl Ball {
    pub fn new() -> Ball {
        let size = BALL_RADIUS * 2;
        Ball {
            vel_x: BALL_VELOCITY_X,
            vel_y: BALL_VELOCITY_Y,
            rect: Rect::new(
                (WINDOW_WIDTH / 2 - BALL_RADIUS) as i32,
                (WINDOW_HEIGHT / 2 - BALL_RADIUS) as i32,
                size,
                size),
        }
    }

    pub fn reset(&mut self) {
        self.vel_x = BALL_VELOCITY_X;
        self.vel_y = BALL_VELOCITY_Y;
    }

    pub fn shift(&mut self) {
        self.rect.set_x(self.rect.x() + self.vel_x);
        self.rect.set_y(self.rect.y() + self.vel_y);

        // collisions
        if self.rect.y() <= 0 {
            // top
            self.vel_y *= -1;
        } if self.rect.y() >= (WINDOW_HEIGHT - 2 * BALL_RADIUS) as i32 {
            // bottom
            self.vel_y += -1;
        } if self.rect.x() <= 0 {
            // left
            self.vel_x *= -1;
        } if self.rect.x() >= (WINDOW_WIDTH - 2 * BALL_RADIUS) as i32 {
            // right
            self.vel_x *= -1;
        }
    }
}

fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();

    let window = video_subsystem.window(TITLE, WINDOW_WIDTH, WINDOW_HEIGHT)
        .position_centered()
        .build()
        .unwrap();

    let mut canvas = window.into_canvas().build().unwrap();
    canvas.set_draw_color(Color::RGB(3, 0, 11));

    let mut fps = FPSManager::new();
    fps.set_framerate(60).unwrap();

    let mut ball = Ball::new();

    let mut event_pump = sdl_context.event_pump().unwrap();
    'running: loop {
        canvas.set_draw_color(Color::RGB(3, 0, 11));
        canvas.clear();

        for event in event_pump.poll_iter() {
            match event {
                Event::Quit {..} |
                Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
                    break 'running
                },
                _ => {}
            }
        }

        ball.shift();
        canvas.set_draw_color(Color::RGB(255, 255, 255));
        canvas.fill_rect(ball.rect).unwrap();

        canvas.present();
        fps.delay();
    }
}
