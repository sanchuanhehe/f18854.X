#include "game.h"

/**
 * @brief 初始化弹幕游戏
 * @param game 弹幕游戏结构体
 */
void init_game(BulletGamePtr game) {
  game->bullet_location = 0;
  game->bullet_position = 0;
  game->man_position = 0;
  game->win_flag = 0;
}

/**
 * @brief 更新弹幕游戏, 弹幕位置循环移动
 * @param game 弹幕游戏结构体
 */
void update_game(BulletGamePtr game) {
  game->bullet_location = (game->bullet_location + 1) % 4;
  if (game->bullet_location == 3) {
    if (game->bullet_position == game->man_position) {
      game->win_flag++;
    }
    game->bullet_location = 0;
  }
}

/**
 * @brief bullet_position++,--操作
 *
 */
void move_bullet(BulletGamePtr game, int8_t direction) {
  game->bullet_position = (game->bullet_position + direction) % 5;
}

/**
 * @brief man_position++,--操作
 *
 */
void move_man(BulletGamePtr game, int8_t direction) {
  game->man_position = (game->man_position + direction) % 5;
}

/**
 * @brief 将game译码为数码管显示,并写入显存
 *
 * @param Display 显示数据结构体指针
 * @param game 弹幕游戏结构体
 */
void displaygame(PDisplayData Display, BulletGamePtr game) {
  // 清空显示
  Display->digit1 = 0;
  Display->digit2 = 0;
  Display->digit3 = 0;
  Display->digit4 = 0;
  switch (game->man_position) {
  case 0:
    Display->digit1 = game_position_0;
    break;
  case 1:
    Display->digit1 = game_position_1;
    break;
  case 2:
    Display->digit1 = game_position_2;
    break;
  case 3:
    Display->digit1 = game_position_3;
    break;
  case 4:
    Display->digit1 = game_position_4;
    break;
  default:
    Display->digit1 = 0;
    break;
  }
  uint8_t *digits;
  switch (game->bullet_location) {
  case 0:
    digits = &(Display->digit4);
    break;
  case 1:
    digits = &(Display->digit3);
    break;
  case 2:
    digits = &(Display->digit2);
    break;
  case 3:
    digits = &(Display->digit4);
    break;
  default:
    digits = &(Display->digit4);
    break;
  }
  switch (game->bullet_position) {
  case 0:
    *digits = game_position_0;
    break;
  case 1:
    *digits = game_position_1;
    break;
  case 2:
    *digits = game_position_2;
    break;
  case 3:
    *digits = game_position_3;
    break;
  case 4:
    *digits = game_position_4;
    break;
  default:
    *digits = 0;
    game->bullet_position = 0;
    break;
  }
}