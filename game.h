#ifndef GAME_H
#define GAME_H
#include <stdint.h>
#include "display.h"

#define game_position_0 0b00000001
#define game_position_1 0b00100000
#define game_position_2 0b01000000
#define game_position_3 0b00010000
#define game_position_4 0b00001000
/**
 * @brief 弹幕游戏结构体
 * @param man_position 小人位置
 * @param bullet_positon 弹幕位置
 * @param bullet_location 弹幕徐进位置
 * @param win_flag 游戏胜利标志
 * 用于描述弹幕游戏中的小人位置、弹幕位置以及弹幕运动轨迹。
 */
typedef struct {
  uint8_t man_position;    /**< 小人位置 */
  uint8_t bullet_position; /**< 弹幕位置 */
  uint8_t bullet_location; /**< 弹幕运动位置 */
  uint8_t win_flag;        /**< 游戏胜利标志 */
} BulletGame, *BulletGamePtr;

/**
 * @brief 初始化弹幕游戏
 * @param game 弹幕游戏结构体
 */
void init_game(BulletGamePtr game);

/**
 * @brief 更新弹幕游戏
 * @param game 弹幕游戏结构体
 */
void update_game(BulletGamePtr game);

/**
 * @brief bullet_position++,--操作
 *
 */
void move_bullet(BulletGamePtr game, uint8_t direction);

/**
 * @brief man_position++,--操作
 *
 */
void move_man(BulletGamePtr game, uint8_t direction);

/**
 * @brief 将game译码为数码管显示,并写入显存
 *
 * @param Display 显示数据结构体指针
 * @param game 弹幕游戏结构体
 */
void displaygame(PDisplayData Display, BulletGamePtr game);

#endif // GAME_H