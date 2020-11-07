# FUNCTION TO GENERATE SEQUENCE OF TRIAL CONDITIONS FOR EACH BLOCK
# for a flanker-switch task
# Author: Marcus Möschl
# Year: 2020
# Affiliation: TU Dresden, Germany
# Contact: marcus.moeschl@tu-dresden.de



# which conditions can be combined ----------------------------------------
# needs the tr_list to be sourced (either here or in the main script)
source(file = "tr_arr_flankerSwitch_MM.R")
# View(tr_list)


### list of target conditions ---> DONE BEFOREHAND!!!
# get potential following conditions for each number in cond_task_stim_congr
# gets the cond_task_stim_congr in which trial_lag1 is in trial_n of the imperative condition.
# i.e., transitions with these cond_task_stim_congr numbers can be combined
# row number = cond_task_stim_congr
pot_next_cond <- matrix(NA, nrow = 64, ncol = 8)
colnames(pot_next_cond) <- c(paste("option_", 1:8, sep = ""))
for (cond_count in c(1:64)) {
  pot_next_items <- tr_list[tr_list[, 1] %in% tr_list[tr_list[, 4] == cond_count, 2], ]
  pot_next_cond[cond_count, 1:8] <- as.numeric(names(table(pot_next_items[, 4])))
}
# View(pot_next_cond)

### list of cond_task_stim for each cond_task_stim_congr ---> DONE BEFOREHAND!!!
# gets the the cond_task_stim_congr numbers that correspond to cond_task_stim
# use this list to balance/manipulate the sequence of cond_task_stim_congr in a block
# row = cond_task_stim, col = transition of congr_fl_rel (CC, CI, IC, II)
tr_limits <- seq(from = 0, to = 61, by = 4)
tr_cond_nums <- matrix(nrow = 16, ncol = 4)
for (i in c(1:16)) {
  tr_cond_nums[i,] <-  c(1:4) + tr_limits[i]
}
# View(tr_cond_nums)
rm(tr_limits)

# list cond_task_stim_congr numbers that correspond to
# task and response repetitions or switches
# use this to check for successive task and/or response repetitions
# table(tr_list[, 4], tr_list[, 3])
rep_task_rep_resp <- (tr_cond_nums[c(1, 4, 5, 8),])
rep_task_sw_resp <- (tr_cond_nums[c(2, 3, 6, 7),])
sw_task_rep_resp <- (tr_cond_nums[c(9, 12, 13, 16),])
sw_task_sw_resp <- (tr_cond_nums[c(10, 11, 14, 15),])




# aims --------------------------------------------------------------------

# find lists of 64 transitions
#   1. each type of transition in cond_tr_task_stim_congr should appear only once
#   2. ideally, task repetitions and response repetition should only occur 2 times in a row
#     --> if this does not work, try to allow more repetitions in a row (max. 3)
#     --> OR: find out how many task repetitions and response repetitions need to be allowed
#           in order to fulfill the criterion that each type
#   3. constraint: cond_tr_task_stim_congr cannot be combined arbitrarily
#      --> see pot_next_cond
#   4. these lists should then be "filled" with the 1024 different unique transitions (possible pairs of 32 stimuli)
#       that can appear in the task in such a way that each transition appears only once across the 16 lists of 64 transitions


# routine to generate transition lists ------------------------------------
# returns a list of lists_needed * 64 transition sequences that will be used for the task
# picks starting item, then iterates through potential next items from which trials can be combined
# then checks balancing and sequence conditions.
# if these fail for all potential items, goes back to the previous item and tries to find a fit.
# if this fails again, goes back another item
# CAUTION:  This sometimes does not go back further than one/two items, which then
#           causes an infinite loop!
#           --> To remedy this, another start item is picked after run_lim is reached
# lists_needed = number of transition sequences/lists to be generated (16 to use all transitions in the task)
# lim_task_rep = maximum consecutive task repetitions (including response switches) (3)
# lim_resp_rep = maximum consecutive response repetitions (including task switches) (3)
# balance_block_halfs = should first and second half contain equal number of the 16
#                       different types of task/response repetitions/switches (FALSE)
#                       --> will not work in combination with
#                           low lim_task_rep/lim_resp_rep and balance_tr_types == TRUE
# balance_tr_types = should each type of transition of task, target, congr (64)
#                    appear only once within the 64 transitions (TRUE)
# run_lim = limit of runs before the script switches to another starting element and starts over (500)
# gen_seed = number of the seed used to generate these lists
#            --> should be the same as for the trial picking script(seed_num)






# function definition start -----------------------------------------------

# fn_gen_cond_lists <-
#   function(lists_needed,
#            lim_task_rep,
#            lim_resp_rep,
#            balance_block_halfs,
#            balance_tr_types,
#            run_lim,
#            gen_seed) {
#
#   set.seed(gen_seed)
#
#   list_fin_count <- 0
#   list_count <- 0
#   finished_lists <- list()
#

# MANUAL RUN ---> DOES NOT WORK
# sink()
  {
    # sink("test_out.txt", append = FALSE)

    lists_needed <-  1
    lim_task_rep <-  3
    lim_resp_rep <-  3
    balance_block_halfs <-  FALSE
    balance_tr_types <-  FALSE
    # run_lim <- 500
    gen_seed <- 999

    set.seed(gen_seed)

    list_fin_count <- 0
    list_count <- 0
    finished_lists <- list()

    failed_items <- matrix(NA, nrow = 64, ncol = 2)
    colnames(failed_items) <- c("item", "trial")
    # previous_item <- 0
    item_fail_count <- 0

  repeat {
    list_count <- list_count + 1
    cond_list_temp <- matrix(NA, nrow = 1, ncol = 64)
    fin_list <- matrix(NA, nrow = 1, ncol = 64)

    list_cond_task_stim_temp <- matrix(NA, nrow = 1, ncol = 64) # at the beginning of the loop

    # tr_rnd_start_items <- sample(1:64)
    tr_rnd_start_items <- c(1:64)

    item_pick_fail <- FALSE
    list_fin <- FALSE
    item_fail_count <- 0
    rep_task_succ_count <- 0
    rep_resp_succ_count <- 0
    trial_count <- 0
    restart_count <- 0
    rc <- 0

    repeat {
    rc <- rc + 1
    trial_count <- trial_count + 1

    # pick/get first/current item ----
    # add first item to the cond_list_temp and get cond_task_stim number
    # for the next trials, the item to check is already in the list
    if (trial_count == 1 & item_pick_fail == TRUE) {
      restart_count <- restart_count + 1
      start_item <-  tr_rnd_start_items[trial_count + restart_count]
      cond_task_stim_start <- which(tr_cond_nums == start_item, arr.ind = TRUE)[1]
      cond_list_temp[trial_count] <- start_item
      list_cond_task_stim_temp[trial_count] <- cond_task_stim_start
      # reset item_pick_fail == TRUE????
      item_pick_fail <-  FALSE
      failed_items <- matrix(NA, nrow = 64, ncol = 2)
      item_fail_count <- 0


    } else if (trial_count == 1 & item_pick_fail == FALSE) {
      # start_item <-  tr_rnd_start_items[trial_count]
      # start_item <-  tr_rnd_start_items[list_count]
      start_item <-  tr_rnd_start_items[trial_count]
      cond_task_stim_start <- which(tr_cond_nums == start_item, arr.ind = TRUE)[1]
      cond_list_temp[trial_count] <- start_item
      list_cond_task_stim_temp[trial_count] <- cond_task_stim_start
    }

    # # reset item_pick_fail == TRUE????
    # item_pick_fail <-  FALSE


    print(paste(list_count, "restart", restart_count,  "start_item", cond_list_temp[1, 1], "runs", rc, "trial_count", trial_count,  "current_item", cond_list_temp[1, trial_count]  ))
    print("failed_items:")
    print(as.numeric(failed_items[, 1]))

    print("current list:")
    listforprint <- cond_list_temp[1, is.na(cond_list_temp[1,]) == FALSE]
    print(listforprint)

    # get available transitions that could follow the current one----
    # get potential target (next) conditions for this item and randomize this list
    # without the items already in the list
    remaining_targets <-
      pot_next_cond[cond_list_temp[1, trial_count], ][!(pot_next_cond[cond_list_temp[1, trial_count],] %in% na.omit(cond_list_temp[1, 1:trial_count ]))]
    print("remaining targets without current item:")
    print(as.numeric(remaining_targets))

    #REMOVE FAILED ITEM!!!
    remaining_targets <- remaining_targets[!(remaining_targets %in% failed_items[, 1])]
    print("remaining targets without current item and failed items:")
    print(as.numeric(remaining_targets))


    if (length(remaining_targets) > 1) {
      # MIT RANDOMISIERUNG
      # rnd_remaining_targets <- sample(remaining_targets)
      # OHNE RANDOMISIERUNG
      rnd_remaining_targets <- remaining_targets
    } else if (length(remaining_targets) == 1) {
      rnd_remaining_targets <- remaining_targets
    } else if (length(remaining_targets) == 0) {
      item_pick_fail <-  TRUE

      ### BACKTRACKING HERE ALSO
      failed_items[item_fail_count, 1] <- cond_list_temp[1, trial_count] # current item
      failed_items[item_fail_count, 2] <- trial_count # current item

      item_fail_count <- item_fail_count + 1
      print(paste("item_fail_count early", item_fail_count, "failed_item", failed_items[failed_items[, 2] == trial_count, 1]))
      # cond_list_temp[trial_count + 1] <- NA
      cond_list_temp[trial_count] <- NA
      list_cond_task_stim_temp[trial_count] <- NA
      trial_count <- trial_count - 2  # go back one iteration???
      next
    }
    # else if (trial_count == 64 & length(remaining_targets) > 0) { # changed!!!
    #   fin_list <- cond_list_temp
    #   break

    ###


    # check how this affects the properties of the list and
    # iterates through potential target items accordingly to balancing requirements
    # use this to manipulate task/response repetition/switch etc.
    for (target_count in 1:length(rnd_remaining_targets)) {
      pot_next <- rnd_remaining_targets[target_count]

      # add the first item temporarily to the list of conditions, to check balancing
      cond_task_stim_pot_next <-
        which(tr_cond_nums == pot_next, arr.ind = TRUE)[1]
      list_cond_task_stim_temp[trial_count] <- cond_task_stim_pot_next
      # print(paste("target_check_count", target_count))

      # balancing and sequence criteria ----
      # check if list is balanced for cond_task_stim up to trial 32 (FALSE by default)
      if (balance_block_halfs == TRUE) {
        tab_cond_task_stim_temp  <- table(list_cond_task_stim_temp)
        if (trial_count <= 32 & any(tab_cond_task_stim_temp > 2)) {
          list_cond_task_stim_temp[trial_count] <- NA
          # print("balancing failed early")
          item_pick_fail <- TRUE
        } else if (trial_count > 32 & any(tab_cond_task_stim_temp > 4)) {
          list_cond_task_stim_temp[trial_count] <- NA
          # print("balancing failed late")
          item_pick_fail <- TRUE
        }
      }

      # check if any cond_task_stim_congr number is used more than once
      if (balance_tr_types == TRUE) {
        tab_cond_task_stim_congr_temp  <- table(cond_list_temp)
        if (any(tab_cond_task_stim_congr_temp > 1)) {
          list_cond_task_stim_temp[trial_count] <- NA
          item_pick_fail <- TRUE
        }
      }

      # check how many successive task repetitions and response repetitions
      if (pot_next %in% rep_task_rep_resp | pot_next %in% rep_task_sw_resp) {
          rep_task_succ_count <-  rep_task_succ_count + 1
      }
      if (pot_next %in% rep_task_rep_resp | pot_next %in% sw_task_rep_resp) {
          rep_resp_succ_count <- rep_resp_succ_count + 1
      }

      # limits for consecutive task/response repetitions ----
      max_task_rep_succ <- lim_task_rep
      max_resp_rep_succ <- lim_resp_rep

      if (rep_task_succ_count > max_task_rep_succ) {
        list_cond_task_stim_temp[trial_count] <- NA
        rep_task_succ_count <- rep_task_succ_count - 1
        item_pick_fail <- TRUE
      }
      if (rep_resp_succ_count > max_resp_rep_succ) {
        list_cond_task_stim_temp[trial_count] <- NA
        rep_resp_succ_count <- rep_resp_succ_count - 1
        item_pick_fail <- TRUE
      }


      # check if balancing and sequence failed with this item ----
      if (item_pick_fail == TRUE & target_count < length(rnd_remaining_targets)) {
        item_pick_fail <- FALSE #reset...
        next
      } else if (item_pick_fail == TRUE & target_count == length(rnd_remaining_targets)) {
        ### BACKTRACK HERE
        failed_items[item_fail_count, 1] <- pot_next # potential next item
        failed_items[item_fail_count, 2] <- trial_count # current item

        item_fail_count <- item_fail_count + 1
        print(paste("item_fail_count late", item_fail_count, "failed_item", failed_items[failed_items[, 2] == trial_count, 1]))
        # cond_list_temp[trial_count + 1] <- NA
        # cond_list_temp[trial_count] <- NA
        list_cond_task_stim_temp[trial_count] <- NA
        trial_count <- trial_count - 2  # go back one iteration???
        break
      } else if (item_pick_fail == FALSE) {
        cond_list_temp[trial_count + 1] <- pot_next # add this item
        # wenn ein passendes gefunden, schmeiß die vorher unpassenden wieder raus
        failed_items[failed_items[, 2] == trial_count, ] <- NA

        # reset repetition counters after switch items
        if (pot_next %in% sw_task_rep_resp | pot_next %in% sw_task_sw_resp) {
          rep_task_succ_count <- 0
        } else if (pot_next %in% rep_task_sw_resp | pot_next %in% sw_task_sw_resp) {
          rep_resp_succ_count <- 0
        }
        break # go out of the target checking loop
      }
    }
    if (trial_count > 63) {
      list_fin <- TRUE
      list_fin_count <- list_fin_count + 1
      fin_list <- cond_list_temp
      finished_lists[[list_fin_count]] <- fin_list
      print(paste(list_fin_count, "lists done"))
      # break
    }
    }

    if (list_fin_count == lists_needed) {
      break
    }
  }
return(finished_lists)
}
cond_list_temp
sink()

# check generated lists ---------------------------------------------------

fin_list_gen <- fin_list
table(fin_list_gen)

# show switches/repeats for one list
checklist <- matrix(NA, nrow = 64, ncol = 4)
colnames(checklist) <- c("tr_num", "cond_task_stim", "task_rep_sw", "resp_rep_sw")
ltocheck <- fin_list_gen

for (i in 1:length(ltocheck)) {
  checklist[i, 1] <- ltocheck[1, i]
  cond_num <- which(tr_cond_nums == ltocheck[1, i], arr.ind = TRUE)[1]
  checklist[i, 2] <- cond_num
  checklist[i, 3] <- ifelse(ltocheck[1, i] %in% rep_task_rep_resp |
                              ltocheck[1, i] %in% rep_task_sw_resp, 1, 2)
  checklist[i, 4] <- ifelse(ltocheck[1, i] %in% rep_task_rep_resp |
                               ltocheck[1, i] %in% sw_task_rep_resp, 1, 2)
}
table(checklist[, 4])

View(checklist)
checklist




# # values to test the function ----
# # list balancing is not correct for task_stim_congr.???
# seed_num <- 999
# lists_test <- fn_gen_cond_lists(lists_needed = 16,
#                                   lim_task_rep = 3,
#                                   lim_resp_rep = 3,
#                                   balance_block_halfs = FALSE,
#                                   balance_tr_types = TRUE,
#                                   run_lim = 500,
#                                   gen_seed = seed_num)
#
# View(lists_test)
#
# # show switches/repeats
# checklist <- matrix(NA, nrow = 64*16, ncol = 7)
# colnames(checklist) <- c("list_num", "tr_num", "cond_task_stim_congr", "cond_task_stim", "task_rep_sw", "resp_rep_sw",  "seed")
# ltocheck <- lists_test
#
# lists_test[[1]][1,]
#
# tr_limits <- seq(from = 0, to = 1024, by = 64)
# for (lc in 1:16) {
#   # checklist[(tr_limits[lc] + 1):(tr_limits[lc]), 1] <- lc
#   # checklist[(tr_limits[lc] + 1):(tr_limits[lc]), 2] <- c(1:64)
#   # checklist[(tr_limits[lc] + 1):(tr_limits[lc]), 7] <- seed_num
#   for (tc in 1:64) {
#     checklist[(tr_limits[lc] + tc), 1] <- lc
#     checklist[(tr_limits[lc] + tc), 2] <- tc
#
#     checklist[(tr_limits[lc] + tc), 3] <- lists_test[[lc]][1, tc]
#     cond_num <- which(tr_cond_nums == lists_test[[lc]][1, tc], arr.ind = TRUE)[1]
#     checklist[(tr_limits[lc] + tc), 4] <- cond_num
#     checklist[(tr_limits[lc] + tc), 5] <-
#       ifelse(lists_test[[lc]][1, tc] %in% rep_task_rep_resp |
#                lists_test[[lc]][1, tc] %in% rep_task_sw_resp, 1, 2)
#     checklist[(tr_limits[lc] + tc), 6] <-
#       ifelse (lists_test[[lc]][1, tc] %in% rep_task_rep_resp |
#                 lists_test[[lc]][1, tc] %in% sw_task_rep_resp, 1, 2)
#
#     checklist[(tr_limits[lc] + tc), 7] <- seed_num
#
#
#
#
#   }
# }
# table(checklist[, 4])
#
# View(checklist)
# checklist
#
#
#


