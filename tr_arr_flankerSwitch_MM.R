# GENERATE POSSIBLE PAIRS OF TRIALS
# for a flanker-switch task
# Author: Marcus Möschl
# Year: 2020
# Affiliation: TU Dresden, Germany
# Contact: marcus.moeschl@tu-dresden.de


# - task uses two letters that can appear in two colors
# - the task itself will display one target letter in the middle of the screen and two identical flanking letters surrounding the target.
# - for each task, only the target letter or color is relevant
# - subjects switch between a letter task and a color task
# - letters and colors indicate different target responses:
#     s = left
#     red = left
#     h = right
#     blue = right
# - each letter appears in each color. colors or letters surrounding the target are always identical
# - this gives 16 possible combinations of letters and colors for each task
#     --> however, these combinations have different "meanings" for each task
#     --> i.e., there are 32 different "stimuli"
# - trial presentation in the task is linear (i.e., only one stimulus per trial)
# - we need to control for the different types of transitions from one trial to the next
# --> combining the 32 different stimuli with each other results in 1024 different unique transitions


# factor combinations (2^5)^2 ---------------------------------------------

tr_list_m <- matrix(NA, nrow = 1024, ncol = 10)
colnames(tr_list_m) <- c(
  "task_lag1",
  "task_n",
  "target_lag1",
  "target_n",
  "lag1_congr_fl_rel",
  "lag1_congr_fl_irr",
  "lag1_congr_tg_irr",
  "n_congr_fl_rel",
  "n_congr_fl_irr",
  "n_congr_tg_irr"
)

tr_count <- 0
for(task_lag1 in c(1:2)) {
  for (task_n in c(1:2)) {
    for (target_lag1 in c(1:2)) {
      for (target_n in c(1:2)) {
        for (lag1_congr_fl_rel in c(1:2)) {
          for (lag1_congr_fl_irr in c(1:2)) {
            for (lag1_congr_tg_irr in c(1:2)) {
              for (n_congr_fl_rel in c(1:2)) {
                for (n_congr_fl_irr in c(1:2)) {
                  for (n_congr_tg_irr in c(1:2)) {
                    tr_count <- tr_count + 1
                    tr_list_m[tr_count, 1:10] <- c(
                      task_lag1,
                      task_n,
                      target_lag1,
                      target_n,
                      lag1_congr_fl_rel,
                      lag1_congr_fl_irr,
                      lag1_congr_tg_irr,
                      n_congr_fl_rel,
                      n_congr_fl_irr,
                      n_congr_tg_irr
                      )
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

# convert to data frame for convenience
tr_list <- as.data.frame(tr_list_m)

# transition of task and stimulus -----------------------------------------

# add variable coding transition of task and stimulus (= target response) for
# transitions from each task and stimulus (= target response)
# 1 = rep_s_s = repeat letter task, repeat stimulus "s"
# 2 = rep_s_h = repeat letter task, switch stimulus "s" to "h"
# 3 = rep_h_s = repeat letter task, switch stimulus "h" to "s"
# 4 = rep_h_h = repeat letter task repeat stimulus "h" to "h"

# 5 = rep_red_red = repeat color task, repeat stimulus "red"
# 6 = rep_red_blue = repeat color task, switch stimulus "red" to "blue"
# 7 = rep_blue_red = repeat color task, switch stimulus "blue" to "red"
# 8 = rep_blue_blue = repeat color task, repeat stimulus "blue" to "blue"

# 9 = sw_s_red = switch from letter to color task, switch stimulus "s" to "red"
# 10 = sw_s_blue = switch from letter to color task, switch stimulus "s" to "blue"
# 11 = sw_h_red = switch from letter to color task, switch stimulus "h" to "red"
# 12 = sw_h_blue = switch from letter to color task, switch stimulus "h" to "blue"

# 13 = sw_red_s = switch from color to letter task, switch stimulus "red" to "s"
# 14 = sw_red_h = switch from color to letter task, switch stimulus "red" to "h"
# 15 = sw_blue_s = switch from color to letter task, switch stimulus "blue" to "s"
# 16 = sw_blue_h = switch from color to letter task, switch stimulus "blue" to "h"

{
  tr_list$cond_tr_task_stim <- 0
  # repeat letter to letter
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 1 & tr_list[, 3] == 1 & tr_list[, 4] == 1] <- 1
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 1 & tr_list[, 3] == 1 & tr_list[, 4] == 2] <- 2
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 1 & tr_list[, 3] == 2 & tr_list[, 4] == 1] <- 3
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 1 & tr_list[, 3] == 2 & tr_list[, 4] == 2] <- 4
  # repeat color to color
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 2 & tr_list[, 3] == 1 & tr_list[, 4] == 1] <- 5
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 2 & tr_list[, 3] == 1 & tr_list[, 4] == 2] <- 6
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 2 & tr_list[, 3] == 2 & tr_list[, 4] == 1] <- 7
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 2 & tr_list[, 3] == 2 & tr_list[, 4] == 2] <- 8
  # switch letter to color
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 2 & tr_list[, 3] == 1 & tr_list[, 4] == 1] <- 9
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 2 & tr_list[, 3] == 1 & tr_list[, 4] == 2] <- 10
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 2 & tr_list[, 3] == 2 & tr_list[, 4] == 1] <- 11
  tr_list$cond_tr_task_stim[tr_list[, 1] == 1 & tr_list[, 2] == 2 & tr_list[, 3] == 2 & tr_list[, 4] == 2] <- 12
  # switch color to letter
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 1 & tr_list[, 3] == 1 & tr_list[, 4] == 1] <- 13
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 1 & tr_list[, 3] == 1 & tr_list[, 4] == 2] <- 14
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 1 & tr_list[, 3] == 2 & tr_list[, 4] == 1] <- 15
  tr_list$cond_tr_task_stim[tr_list[, 1] == 2 & tr_list[, 2] == 1 & tr_list[, 3] == 2 & tr_list[, 4] == 2] <- 16
  # table(tr_list$cond_tr_task_stim)
}



# transition of task, stimulus and congruency -----------------------------

# add variable coding transition of task, stimulus and congruency for
# transitions from each task, stimulus, congruency
# codes for each cond_tr_task_stim whether transition is
# 1 = from congruent to congruent
# 2 = from congruent to incongruent
# 3 = from incongruent to congruent
# 4 = from incongruent to incongruent
# (exemplary for cond_tr_task_stim == 1)
# --> add 4 for the same each increment in cond_tr_task_stim
{
  tr_list$cond_tr_task_stim_congr <- 0
  tr_limits <- seq(from = 0, to = 61, by = 4)

  # names(tr_list)
  for(tr_cond_i in c(1:16)){
    tr_list$cond_tr_task_stim_congr[tr_list[, 11] == tr_cond_i & tr_list[, 6] == 1 & tr_list[, 9] == 1] <- 1 + tr_limits[tr_cond_i]
    tr_list$cond_tr_task_stim_congr[tr_list[, 11] == tr_cond_i & tr_list[, 6] == 1 & tr_list[, 9] == 2] <- 2 + tr_limits[tr_cond_i]
    tr_list$cond_tr_task_stim_congr[tr_list[, 11] == tr_cond_i & tr_list[, 6] == 2 & tr_list[, 9] == 1] <- 3 + tr_limits[tr_cond_i]
    tr_list$cond_tr_task_stim_congr[tr_list[, 11] == tr_cond_i & tr_list[, 6] == 2 & tr_list[, 9] == 2] <- 4 + tr_limits[tr_cond_i]
  }
  table(tr_list$cond_tr_task_stim_congr)
}
# View(tr_list[tr_list[, 11] == 1,])


# transition variables for convenience  -----------------------------------

tr_list$task_rep_sw <- ifelse(tr_list$task_lag1 == tr_list$task_n, 1, 2)
tr_list$target_rep_sw <- ifelse(tr_list$target_lag1 == tr_list$target_n, 1, 2)
tr_list$tr_congr_fl_rel <- tr_list$lag1_congr_fl_rel + tr_list$n_congr_fl_rel
tr_list$tr_congr_fl_rel[tr_list$lag1_congr_fl_rel == 1 & tr_list$n_congr_fl_rel == 1] <- 1
tr_list$tr_congr_fl_rel[tr_list$lag1_congr_fl_rel == 1 & tr_list$n_congr_fl_rel == 2] <- 2
tr_list$tr_congr_fl_rel[tr_list$lag1_congr_fl_rel == 2 & tr_list$n_congr_fl_rel == 1] <- 3
tr_list$tr_congr_fl_rel[tr_list$lag1_congr_fl_rel == 2 & tr_list$n_congr_fl_rel == 2] <- 4



# trial types in lag 1 and n ----------------------------------------------

# this codes the type of stimulus that can be presented in trial lag1 and trial n
# this is used to "fill" the sequence of cond_tr_task_stim_congr for each block.
# values 1-16 = possible stimuli for the letter task
# values 17-32 = possible stimuli for the letter task



tr_list$trial_lag1 <- 0
tr_list$trial_n <- 0
tr_count <-  0

for(task_i in c(1:2)) {
  for (target_i in c(1:2)) {
    for (congr_fl_rel_i in c(1:2)) {
      for (congr_fl_irr_i in c(1:2)) {
        for (congr_tg_irr_i in c(1:2)) {
          tr_count <- tr_count + 1

          tr_list$trial_lag1[tr_list$task_lag1 == task_i &
                               tr_list$target_lag1 == target_i &
                               tr_list$lag1_congr_fl_rel == congr_fl_rel_i &
                               tr_list$lag1_congr_fl_irr == congr_fl_irr_i &
                               tr_list$lag1_congr_tg_irr == congr_tg_irr_i] <-
            tr_count

          tr_list$trial_n[tr_list$task_n == task_i &
                            tr_list$target_n == target_i &
                            tr_list$n_congr_fl_rel == congr_fl_rel_i &
                            tr_list$n_congr_fl_irr == congr_fl_irr_i &
                            tr_list$n_congr_tg_irr == congr_tg_irr_i] <-  tr_count

        }
      }
    }
  }
}

# View(a)
# table( tr_list$trial_lag1)
# table( tr_list$trial_lag1,  tr_list$trial_n)


# transition number -------------------------------------------------------
# identifier for stimulus transitions/combinations
tr_list$tr_num <- c(1:1024)


# reorder columns ---------------------------------------------------------
# names(tr_list)
tr_list <- tr_list[ , c(16:17, 11, 12, 1:10, 13:15, 18)]
# View(tr_list)

# clean up ----------------------------------------------------------------

rm(
  tr_list_m,
  "congr_fl_irr_i",
  "congr_fl_rel_i",    "congr_tg_irr_i",    "lag1_congr_fl_irr",
  "lag1_congr_fl_rel", "lag1_congr_tg_irr" ,"n_congr_fl_irr" ,   "n_congr_fl_rel",
  "n_congr_tg_irr" ,   "target_i"  ,        "target_lag1"  ,     "target_n",
  "task_i"    ,        "task_lag1"      ,   "task_n"       ,     "tr_cond_i",
  "tr_count"    ,      "tr_limits"
)
