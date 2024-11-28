package com.spaceme.user.domain;

import com.spaceme.common.AlienConcept;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
public class UserPreference {
    @Id
    private Long id;

    @MapsId
    @OneToOne(targetEntity = User.class, fetch = FetchType.LAZY, optional = false)
    private User user;

    @Setter
    private String spaceGoal;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private AlienConcept alienConcept = AlienConcept.DEFAULT;

    @Column(nullable = false)
    private NotificationPreference notificationPreference;
}